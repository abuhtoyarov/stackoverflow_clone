class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  validates :title, presence: true, length: { in: 15..255 }
  validates :body, presence: true
  validates :user_id, presence: true
end
