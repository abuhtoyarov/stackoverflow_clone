class Answer < ActiveRecord::Base
  scope :by_rating, -> { order(is_accepted: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, :user_id, presence: true

  def accept
    question.answers.update_all(is_accepted: false)
    update(is_accepted: true)
  end
end
