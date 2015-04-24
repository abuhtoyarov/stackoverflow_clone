class Attachment < ActiveRecord::Base
  belongs_to :question

  delegate :filename, to: :file

  mount_uploader :file, FileUploader
end
