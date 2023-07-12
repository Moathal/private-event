# To deliver this notification:
#
# InviteNotification.with(post: @post).deliver_later(current_user)
# InviteNotification.with(post: @post).deliver(current_user)

class AttendNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  
  # def initialize(params)
  #   super
  #   @params = params
  # end

  # Add required params
  #
  param :event

  # The message deliverd to user
  def message
    @event = params[:event]
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

  # Define helper methods to make rendering easier.
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

  def message_decider_for_action_of_event_creator(status, creator)
    if status == 'canceled'
      "#{creator.fullname} cancelled your invitation to his event"
    else
      "#{creator.fullname} invited you to his event"
    end
  end

  # The link provided
  def url
    if params[:event] != 'deleted'
      event_path(params[:event])
    else 
      events_path
    end
  end
end
