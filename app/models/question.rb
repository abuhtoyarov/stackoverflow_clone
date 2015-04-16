class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { in: 15..255 }
  validates :body, presence: true
  validates :user_id, presence: true
end
