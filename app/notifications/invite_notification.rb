# To deliver this notification:
#
# InviteNotification.with(post: @post).deliver_later(current_user)
# InviteNotification.with(post: @post).deliver(current_user)

class InviteNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  
  def initialize(status, action, event)
    @status = status
    @event = event
  end

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @creator = @event.creator
    @user = User.find(params[:attedance][:user_id])
    case @status
      when "canceled"
        "#{@creator.fullname} cancelled your invitation to his event"
      when "pending"
        "#{@creator.fullname} invited you to his event"
      when "accepted"
        "#{@user.fullname} accepted your invite"
      when "rejected"
        "#{@user.fullname} rejected your invite"
      else
        "#{@status.fullname} is attending your event"
    end
  end
  
  def url
    event_path(Event.find(params[:attendance][:event_id]))
  end
end
