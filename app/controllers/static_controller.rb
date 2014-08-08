class StaticController < ApplicationController
  def index
    @events = Event.all

    respond_to do |format|
      format.html
      format.json {
        render :layout => false,
        :json => @events.to_json
      }
    end
  end

  def teams
    # TODO helper to get team and event from params
    @ekey = params[:event_key]
    event = Event.find_by_key(@ekey)

    if (!event)
      render '/'
      return
    end

    @teams = Team.find_all_by_event_id(event)

    respond_to do |format|
      format.html
      format.json {
        render :layout => false,
        :json => @teams.to_json
      }
    end
  end
end
