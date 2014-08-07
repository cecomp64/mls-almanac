class TeamController < ApplicationController
  def index
    @event = get_event
    @event = (@event) ? @event : get_latest_event
    @team = get_team

    # Need at least a team
    if (!@team or !@event)
      flash[:error] = "No team found.  Please check your request."
      redirect_to '/' and return
    end

    # Get Schedule
    next_five = schedule(@event, @team, "games.play_at ASC", "games.score1 is null").limit(5)
    last_five = schedule(@event, @team, "games.play_at DESC", "games.score1 is not null").limit(5).reverse
    @schedule = last_five + next_five

    # Get Roster Rows and Headings
    @roster = players_with_stats(@event, @team)
    @headings = ["name", "position"]
    @roster_rows = []
    @roster.each do |player|
      @roster_rows << {"name" => player.person.name, "position" => player.person.player_stats[0].position}
    end

    # Compute top scorers
    @scorers = @roster.order("player_stats.totalGoals DESC").limit(2)

    # Compute available years

    # Compute record
    @standing = get_standings(@event, @team)
  end
end
