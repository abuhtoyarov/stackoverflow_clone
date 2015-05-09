require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def score
    votes.sum(:points)
  end
end
