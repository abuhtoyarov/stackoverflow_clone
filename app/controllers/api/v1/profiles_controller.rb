class Api::V1::ProfilesController < ApplicationController
  skip_authorization_check
  before_action :doorkeeper_authorize!
  before_action :current_resource_owner
  before_action :find_users, only: :index

  respond_to :json

  def me
    respond_with @current_resource_owner
  end

  def index
    respond_with @users
  end

  protected

  def current_resource_owner
    user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    @current_resource_owner ||= user
  end

  def find_users
    @users = User.all_without(@current_resource_owner)
  end
end
