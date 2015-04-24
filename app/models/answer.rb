class Answer < ActiveRecord::Base
  scope :by_rating, -> { order(accepted: :desc) }

  has_many :attachments, as: :attachable
  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :attachments

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
