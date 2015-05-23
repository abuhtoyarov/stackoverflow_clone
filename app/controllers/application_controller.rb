require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to new_user_session_path, alert: exception.message + t("sign_in") }
      format.js do
        flash[:alert] = exception.message + t("sign_in")
        render js: "window.location = '#{new_user_session_path}'"
      end
      format.json do
        flash[:alert] = exception.message + t("sign_in")
        render js: "window.location = '#{new_user_session_path}'"
      end
    end
  end
  # check_authorization unless: :devise_controller?
end
