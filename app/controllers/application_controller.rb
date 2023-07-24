require "application_responder"

class ApplicationController < ActionController::Base
  include Turbo::Streams::Broadcasts
  self.responder = ApplicationResponder
  respond_to :html
  
  include Noticed

  # after_action :receive_notifications, if: :current_user && -> { controller_name == 'events' && action_name.in?(['create', 'attend', 'reject_invite', 'invite', 'cancel_invitation', 'accept_invite', 'update']) }

  before_action -> { set_notification(nil) }, if: :current_user

  before_action :configure_permitted_parameters, if: :devise_controller?


  # def receive_notifications
  #   puts '<><><><><><><><><><><><><><><><><><><><><><><> RECEIVE_NOTIFICATION IS TRIGGERED <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><<><><><>'
  #   notifications = Notification.where(recipient_id: current_user.id).newest_first.limit(9)
  #   if notifications.any?
  #     Turbo::StreamsChannel.broadcast_replace_to(target: 'notifications', partial: 'layouts/notifications', locals: { notifications: set_notification(notifications) })
  #   end
  # end

  private
  
  def set_notification(notifications)
    puts '<><><><><><><><><><><><><><><><><><><><><><><> SET NOTIFICATIONS IS TRIGGERED <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><<><><><>'
    if notifications.nil?
      puts '<><><><><><><><><><><><><><><><><><><><><><><> IT WAS NOT TRIGGERED FROM RECEIVE_NO... <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><<><><><>'
      @notifications = Notification.where(recipient_id: current_user.id).newest_first.limit(9)
    else
      puts '<><><><><><><><><><><><><><><><><><><><><><><> IT WAS TRIGGERED FROM RECEIVE_NO... <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><<><><><>'
      @notifications = notifications.where(recipient_id: current_user.id).newest_first.limit(9)
    end
    
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname, :birthday])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :birthday])
  end
end
