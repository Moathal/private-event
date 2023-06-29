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

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @event = Event.find(params[:attendance][:event_id])
    @user = User.find(@event.creator_id)
    "#{@user.fullname} cancelled your invitation to his event"
  end
  
  def url
    event_path(Event.find(params[:attendance][:event_id]))
  end
end
