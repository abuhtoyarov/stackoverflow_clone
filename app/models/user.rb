class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers

  def owner?(obj)
    obj.try(:user_id) && obj.user_id == id
  end

  def can_vote?(obj)
    !owner?(obj) && obj.votes.find_by(user_id: id).nil?
  end
end
