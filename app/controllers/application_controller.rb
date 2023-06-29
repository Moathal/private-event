require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :set_notification, if: :current_user

  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  
  def set_notification
    notifications = Notification.where(recipient_id: current_user.id).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname, :birthday])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :birthday])
  end
end
