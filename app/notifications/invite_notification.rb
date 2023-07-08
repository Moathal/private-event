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
    puts "<><><><><><>><>><><><><><><><><><><><><><><><><><><><><><><><><THE MESSAGE METHOD IS WORKING><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>"
    @event = params[:event]
    @creator = params[:creator]
    @status = params[:status]
    @attend_id = params[:attend_id]
    @user = params[:user]
    puts "ATTENDANCE PASSED TO NOTIFICATION MESSAGE #{@attendance}"
    puts "USER PASSED TO NOTIFICATION MESSAGE #{@user}"
    puts "EVENT PASSED TO NOTIFICATION MESSAGE #{@event}"
    puts "CREATOR PASSED TO NOTIFICATION MESSAGE #{@creator}"
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
    when 'cancel_attend'
      "#{@user.fullname} is not attending your event"
    else
      "#{@user.fullname} is attending your event"
    end
  end
  
  def url
    event_path(params[:event])
  end
end
