require 'active_support/concern'

module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_resource, only: [:vote_up, :vote_down, :unvote]
    before_action :auth_user_vote, only: [:vote_up, :vote_down]
  end

  def vote_up
    @vote = @resource.votes.build
    respond_to do |format|
      format.json do
        if @vote.up(current_user)
          render @vote
        else
          render json: @vote.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def vote_down
    @vote = @resource.votes.build
    respond_to do |format|
      format.json do
        if @vote.down(current_user)
          render @vote
        else
          render json: @vote.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def unvote
    @vote = @resource.votes.find_by(user_id: current_user)
    respond_to do |format|
      format.json do
        if @vote.delete
          render @vote
        else
          render json: @vote.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def auth_user_vote
    return if current_user && current_user.can_vote?(@resource)
    flash[:error] = "You can't vote. Login or unvote first"
    render @resource
  end
end
