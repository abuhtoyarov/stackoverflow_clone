class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :current_resource_owner
  before_action :find_users, only: :index
  respond_to :json

  authorize_resource class: false

  def me
    respond_with @current_resource_owner
  end

  def index
    respond_with @users
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def find_users
    @users = User.all_without(@current_resource_owner)
  end
end
