# To deliver this notification:
#
# EventNotification.with(post: @post).deliver_later(current_user)
# EventNotification.with(post: @post).deliver(current_user)

class EventNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :event

  # Define helper methods to make rendering easier.
  #
  def message
    creator = params[:creator]
    action = params[:action]
    event = params[:event]
    if action == 'create'
      "#{creator.fullname} added new event"
    else 
      "The event #{event.name} has been cancelled!!"
    end
  end
  #
  def url
    events_path(params[:event])
  end
end
