class ScheduleController < ApplicationController
  def index
    name_h = "name"
    @ekey = params[:event_key]
    @tkey = params[:team_key]
    @timezone = params[:tz] ? params[:tz] : "Eastern Time (US & Canada)"

    # Find the schedule for this event and team
    @event = Event.find_by_key(@ekey)
    @team = Team.find_by_key(@tkey)

    # Error if no event specified
    if (@event == nil)
      @schedule = []
      flash.now[:error] = "Could not find a matching event.  Please check your request."
      redirect_to '/'
      return
    else
      @schedule = schedule(@event, @team)
      @standings = get_standings(@event)
      if (@team)
        @team_standing = @standings.find_by_team_id(@team)
      end
    end

    respond_to do |format|
      format.html
      format.json {
        render :layout => false,
        :json => (@tkey == "standings") ? @standings.to_json() : @schedule.to_json()
      }
    end

  end

end
