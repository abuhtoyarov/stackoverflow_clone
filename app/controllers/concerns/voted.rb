require 'active_support/concern'

module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_resource, only: [:vote_up, :vote_down, :unvote]
    before_action :build_vote, only: [:vote_up, :vote_down]
    respond_to :json, only: [:vote_up, :vote_down, :unvote]
  end

  def vote_up
    respond_with(@vote.up(current_user), template: vote_template!)
  end

  def vote_down
    respond_with(@vote.down(current_user), template: vote_template!)
  end

  def unvote
    @vote = @resource.votes.find_by(user_id: current_user)
    respond_with(@vote.delete, template: vote_template!)
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def build_vote
    @vote = @resource.votes.build
  end

  def vote_template!
    'votes/_vote.json.jbuilder'
  end
end
