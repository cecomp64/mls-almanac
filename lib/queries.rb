module Queries
  # Get the schedule for a team during a season
  # If team is nil, then get the schedule for the whole
  # season
  def schedule(event, team, order_by = "games.play_at", where_by="")
    if (event and team)
      return Game.joins(:round).where("rounds.event_id = #{event.id}").where("games.team1_id = #{team.id} or games.team2_id=#{team.id}").order(order_by).includes(:team1, :team2).where(where_by).page(params[:page]).per(30)
    elsif (event)
      return Game.joins(:round).where("rounds.event_id = #{event.id}").order(order_by).includes(:team1, :team2).where(where_by).page(params[:page]).per(30)
    end
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
  def players_with_stats(event, team = nil, order_by="", where_by="")
    if (team.nil?)
      return SportDb::Model::Roster.where(:event_id => event).includes(:person => :player_stats).references(:player_stats).where("player_stats.event_id = #{event.id}").order(order_by).where(where_by)
    else
      return SportDb::Model::Roster.where(:event_id => event, :team_id => team).includes(:person => :player_stats).references(:player_stats).where("player_stats.event_id = #{event.id} and player_stats.team_id = #{team.id}").order(order_by).where(where_by)
    end
  end


  # Find the latest event - useful for a default event if one is needed
  def get_latest_event
    return Event.all.order("start_at desc").limit(1)[0]
  end

  # Return the standings of teams in an event
  def get_standings(event, team=nil)
    # If necessary, recompute the standings
    es = SportDb::Model::EventStanding.find_by_event_id(event)
    if (!es)
      es = SportDb::Model::EventStanding.create(event: event)
      es.recalc!
    end

    # Return ordered standings
    if (team)
      return es.entries.where(:team_id => team).first
    else
      return es.entries.order("pos ASC").includes("team")
    end
  end


end
