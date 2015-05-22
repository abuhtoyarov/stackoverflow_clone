class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth
  before_action :find_user_with_oauth, except: [:confirm_email]

  def facebook
    return if sign_in_user
  end

  def twitter
    return if sign_in_user
    flash[:notice] = 'Please enter email to continue'
    render 'omniauth_callbacks/confirm_email', locals: { auth: @auth }
  end

  def confirm_email
    if valid_email?
      find_user_with_oauth
      return if sign_in_user
    else
      flash[:notice] = 'Please enter valid email to continue'
      render 'omniauth_callbacks/confirm_email', locals: { auth: @auth }
    end
  end

  private

  def set_auth
    @auth = request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end

  def find_user_with_oauth
    @user = User.find_for_oauth(@auth)
  end

  def sign_in_user
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @auth.provider.capitalize ) if is_navigational_format?
    end
  end

  def valid_email?
    @auth.info.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end
