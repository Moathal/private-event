#  This class is to deliver Attendance notification
 # - Triggered by Attendance model.
 # - It deals with event invitations and attendances

## The call for this class methods happens in _notification.html.erb.
#

class AttendNotification < Noticed::Base
  # delivery methods
  deliver_by :database

  # The param passed to URL method
  param :event

  # The notification message deliverd to user
  def message
    creator = params[:creator]
    status = params[:status]
    user = params[:user]
    case status
    when 'canceled', 'pending'
      message_decider_for_action_of_event_creator(status, creator)
    else
      message_decider_for_action_of_attendee(status, user)
    end
  end

  ## Helper methods ##

  # Speceify notifications messages that are sent to event attendees
  def message_decider_for_action_of_attendee(status, event_attendee)
    case status
    when 'accepted'
      "#{event_attendee.fullname} accepted your invite"
    when 'rejected'
      "#{event_attendee.fullname} rejected your invite"
    when 'cancel_attend'
      "#{event_attendee.fullname} is not attending your event"
    else
      "#{event_attendee.fullname} is attending your event"
    end
  end

  # Speceify notifications messages that are sent to event creator
  def message_decider_for_action_of_event_creator(status, creator)
    if status == 'canceled'
      "#{creator.fullname} cancelled your invitation to his event"
    else
      "#{creator.fullname} invited you to his event"
    end
  end

  # The link for the event when notification is clicked
  def url
    event_path(params[:event])
  end
end
