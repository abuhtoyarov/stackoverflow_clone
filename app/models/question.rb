class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { in: 15..255 }
  validates :body, presence: true
end
