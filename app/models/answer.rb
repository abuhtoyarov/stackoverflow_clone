class Answer < ActiveRecord::Base
  belongs_to :question

  attr_accessor :body
  validates :body, presence: true
end
