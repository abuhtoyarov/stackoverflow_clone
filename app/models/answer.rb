class Answer < ActiveRecord::Base
  scope :by_rating, -> { order(accepted: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, :user_id, presence: true

  def accept
    return if accepted?
    question.answers.update_all(accepted: false)
    update(accepted: true)
  end

  # def accepted?
  #   is_accepted
  # end
end
