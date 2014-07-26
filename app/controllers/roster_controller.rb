class RosterController < ApplicationController

  # List the roster of a team for a given year (event)
  # FIXME: This relies on valid stat data being available
  #   For each player.  Separate this into a view with no stats
  #   and a view with some or all stats
  def index
    name_h = "name"
    @ekey = params[:event_key]
    @tkey = params[:team_key]
    @generic_stats = params[:all_stats]
    #@asc = params[:asc] ? params[:asc] : "DESC"
    @asc = params[:asc] ? params[:asc].to_i : 0
    ascention = ["DESC", "ASC"]
    @order_by = params[:order_by] ? "player_stats.#{params[:order_by]} #{ascention[@asc]}" : ""
    @filter = (params[:fn] and params[:fv]) ? "player_stats.#{params[:fn]}=\"#{params[:fv]}\"" : ""

    # Name is in persons table, all other keys are in player_stats
    if (params[:order_by] == name_h) 
      @order_by.sub!("player_stats", "persons")
    end
    if (params[:fn] == name_h)
      @filter.sub!("player_stats", "persons")
    end

    #TBD: render a default view
    if (@ekey == nil or @tkey == nil)
      redirect_to root_url
      return
    end

    # Find the roster for this event and team
    @event = Event.find_by_key(@ekey)
    @team = Team.find_by_key(@tkey)

    #TBD: render a default view
    if (@event == nil or @team == nil)
      @roster = []
      flash.now[:error] = "Could not find a matching event or team.  Please check your request."
      redirect_to '/'
      return
    else
      # TBD - Query the player_stats for easy sorting, and work backwards for the person data
      #@roster = SportDb::Model::Roster.find_all_by_event_id_and_team_id(@event, @team)
      @roster = players_with_stats(@event, @team, @order_by, @filter)
      @roster = Kaminari.paginate_array(@roster).page(params[:page]).per(30)
    end

    # build a table with the proper headings
    @headings = []

    pos_h = "position"
    keys = []
    keys << name_h
    keys << pos_h

    # Create a flat list of generic stat_data
    if (@generic_stats)
      keys += @roster.each.map{|r| r.person.stat_data.where(:event_id => @event.id, :team_id => @team.id).each.map {|s| s.stat.key}}.flatten
    end

    # remove duplicates
    # Relying on set being ordered, so the view
    #  can parse items in the same order every time
    @headings = keys.to_set
    @roster_rows = []

    # Get all the stat_data
    @roster.each do |r|
      row = {}
      row[name_h] = r.person.name

      # Additional stat data
      if (@generic_stats)
        r.person.stat_data.where(:event_id => @event.id, :team_id => @team.id).each do |sd|
          row[sd.stat.key] = sd.value
        end
      end

      # Builtin stat data
      # This will return a collection of PlayerStat items, but if the
      # database is coherent, there is only one valid entry
      ps = r.person.player_stats[0]

      if (ps)
        # Grab all but a few items in PlayerStat
        # FIXME: Move this into a helper
        ps.attributes.each do |attr, val|
          case(attr)
            when "id", "person_id", "team_id", "game_id", "created_at", "event_id", "updated_at", "wins", "losses", "draws", "subOuts", "minutesPlayed"
              next
          else
            row[attr] = val
            @headings << attr
          end
        end # each attr
      else
        flash.now[:warn] = "Could not find any stats for #{r.person.name}"
      end
      @roster_rows << row
    end

    respond_to do |format|
      format.html
      format.json {
        render :layout => false,
        :json => @roster_rows.to_json()
      }
    end
    #debugger
  end

  # Get a roster with all stats for each player on this team in one query
  #  Note that since the query is structured to return 
  #  only player stats that match this person, event, and team,
  #  the reference to roster[n].person.player_stats will match
  #  with the query's team and event.  There could be other entries
  #  in PlayerStat with same person and different event, team, but those
  #  will not match roster[n].person.player_stats (as intended!)
  #
  # NOTE: If a player has no stats, they will not end up in this record
  def players_with_stats(event, team, order_by="", where_by="")
    return SportDb::Model::Roster.where(:event_id => event, :team_id => team).includes(:person => :player_stats).references(:player_stats).where("player_stats.event_id = #{event.id} and player_stats.team_id = #{team.id}").order(order_by).where(where_by)
  end

end
