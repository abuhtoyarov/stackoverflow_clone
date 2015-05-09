class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :points, presence: true

  DEFAULT_POINT = 1

  def up(user)
    take_vote(user, :up)
  end

  def down(user)
    take_vote(user, :down)
  end

  private

  def take_vote(user, option)
    self.user_id = user.id
    if option == :up
      self.points = DEFAULT_POINT
    elsif option == :down
      self.points = -1 * DEFAULT_POINT
    else
      return
    end
    save
  end
end
