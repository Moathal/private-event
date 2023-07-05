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

  
  # def initialize(params)
  #   super
  #   @params = params
  # end

  # Add required params
  #
    param :event

  # Define helper methods to make rendering easier.
  #
  def message
    @event = Event.find(params[:attendance][:event_id])
    @creator = @event.creator
    @status = params[:attendance][:status]
    @user = User.find(params[:attendance][:user_id])
    puts "STATUS PASSED TO NOTIFICATION MESSAGE #{@status}"
    case @status
      when 'canceled'
        "#{@creator.fullname} cancelled your invitation to his event"
      when 'pending'
        "#{@creator.fullname} invited you to his event"
      when 'accepted'
        "#{@user.fullname} accepted your invite"
      when 'rejected'
        "#{@user.fullname} rejected your invite"
      else
        "#{@user.fullname} is attending your event"
    end
  end
  
  def url
    event_path(Event.find(params[:attendance][:event_id]))
  end
end
