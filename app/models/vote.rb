class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true
  validates :points, presence: true

  DEF_POINT = 1

  def voteup(user)
    self.user_id = user.id
    self.points = DEF_POINT
    save
  end
end
