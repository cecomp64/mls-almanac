class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Mixin some common query functions
  include Queries

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

end
