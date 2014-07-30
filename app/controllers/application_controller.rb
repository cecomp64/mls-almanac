class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Pull team from the url
  def get_team
    if (!params[:team_key])
      return nil
    else
      team = Team.find_by_key(params[:team_key])
      if (!team)
        return nil
      else
        return team
      end
    end
  end

  # Pull event from the url
  def get_event
    if (!params[:event_key])
      return nil
    else
      event = Event.find_by_key(params[:event_key])

      if (!event)
        return nil
      else
        return event
      end
    end

  end

  # Find the event and team based on params
  # Return nil if it can't find both
  def get_event_and_team
    event = get_event
    team = get_team

    if (!event or !team)
      return nil
    else
      return [event, team]
    end
  end

  # Find the latest event - useful for a default event if one is needed
  def get_latest_event
    return Event.all.order("start_at desc").limit(1)[0]
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

  # Get the schedule for a team during a season
  # If team is nil, then get the schedule for the whole
  # season
  def schedule(event, team, order_by = "games.play_at", where_by="")
    if (event and team)
      return Game.joins(:round).where("rounds.event_id = #{event.id}").where("games.team1_id = #{team.id} or games.team2_id=#{team.id}").order(order_by).includes(:team1, :team2).where(where_by)
    elsif (event)
      return Game.joins(:round).where("rounds.event_id = #{event.id}").order(order_by).includes(:team1, :team2).where(where_by).page(params[:page]).per(30)
    end
  end

end
