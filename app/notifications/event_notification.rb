#  This class is to deliver Event notification
 # - Triggered by Event model.
 # - It deals with event create and update

## The call for this class methods happens in _notification.html.erb.


class EventNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database

  # The param passed to URL method
  param :event

  # The notification message deliverd to user
  def message
    creator = params[:creator]
    action = params[:action]
    event = params[:event]
    if action == 'create'
      "#{creator.fullname} added new event"
    else 
      "The event #{event.name} has been updated!!"
    end
  end

  # The link for the event when notification is clicked
  def url
    events_path(params[:event])
  end
end
