require 'active_support/concern'

module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_resource, only: [:voteup, :votedown, :unvote]
    before_action :auth_user_vote, only: [:voteup, :votedown]
  end

  def voteup
    @vote = @resource.votes.build
    respond_to do |format|
      if @vote.vote(current_user, :up)
        format.json { render @vote }
      else
        format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def votedown
    @vote = @resource.votes.build
    respond_to do |format|
      if @vote.vote(current_user, :down)
        format.json { render @vote }
      else
        format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def unvote
    @vote = @resource.votes.find_by(user_id: current_user)
    respond_to do |format|
      if @vote.delete
        format.json { render @vote }
      else
        format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def auth_user_vote
    return if current_user.can_vote?(@resource)
    flash[:error] = "You can't vote. Login or unvote first"
    render @resource
  end
end
