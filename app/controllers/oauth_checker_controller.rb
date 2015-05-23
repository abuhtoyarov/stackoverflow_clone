class OauthCheckerController < ApplicationController
  before_action :set_auth

  def confirm_email
    if valid_email?
      return if sign_in_user
    else
      flash[:notice] = 'Please enter valid email to continue'
      render 'oauth_checker/confirm_email'
    end
  end

  private

  def valid_email?
    @auth.info.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  def set_auth
    @auth = OmniAuth::AuthHash.new(session["devise.omniauth"])
    @auth.info.email = params[:email]
  end

  def sign_in_user
    @user = User.find_for_oauth(@auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @auth.provider.capitalize ) if is_navigational_format?
    end
  end
end
