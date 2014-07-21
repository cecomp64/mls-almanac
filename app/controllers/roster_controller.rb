class RosterController < ApplicationController
  def index
    @ekey = params[:event_key]
    @tkey = params[:team_key]

    #TBD: render a default view
    if (@ekey == nil or @tkey == nil)
      redirect_to root_url
    end

    # Find the roster for this event and team
    @event = Event.find_by_key(@ekey)
    @team = Team.find_by_key(@tkey)

    #TBD: render a default view
    if (@event == nil or @team == nil)
      @roster = []
      flash.now[:error] = "Could not find a matching event or team.  Please check your request."
      redirect_to '/'
    else
      # TBD - Query the player_stats for easy sorting, and work backwards for the person data
      @roster = SportDb::Model::Roster.find_all_by_event_id_and_team_id(@event, @team)
      @roster = Kaminari.paginate_array(@roster).page(params[:page]).per(30)
    end

    # build a table with the proper headings
    @headings = []

    # Create a flat list of generic stat_data
    name_h = "name"
    keys = @roster.each.map{|r| r.person.stat_data.each.map {|s| s.stat.key}}.flatten
    keys << name_h
    keys.reverse!

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
      r.person.stat_data.each do |sd|
        row[sd.stat.key] = sd.value
      end

      # Builtin stat data
      #  TBD: need to add team id to te player data
      ps = r.person.player_stats.find_by_event_id(@event.id)
      ps.attributes.each do |attr, val|
        case(attr)
          when "id", "person_id", "team_id", "game_id", "created_at", "event_id", "updated_at"
            next
        else
          row[attr] = val
          @headings << attr
        end
      end # each attr
      @roster_rows << row
    end
  end

end
