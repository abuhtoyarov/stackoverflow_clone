class Question < ActiveRecord::Base
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  has_many :comments, dependent: :destroy, as: :commentable
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true, length: { in: 15..255 }
  validates :body, presence: true
  validates :user_id, presence: true

  def destroy
    if answers.count == 0
      super
    else
      errors[:base] << "Can't delete question with answers"
      return self
    end
  end
end
