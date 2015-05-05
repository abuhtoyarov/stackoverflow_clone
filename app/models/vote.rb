class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true
  validates :points, presence: true

  DEF_POINT = 1

  def vote(user, option)
    self.user_id = user.id
    if option == :up
      self.points = DEF_POINT
    elsif option == :down
      self.points = -1 * DEF_POINT
    else
      return
    end
    save
  end
end
