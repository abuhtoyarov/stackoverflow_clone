FactoryGirl.define do
  factory :attachment do
    file ActionDispatch::Http::UploadedFile.new(
      tempfile: File.new("#{Rails.root}/spec/fixtures/file.txt"),
      filename: "file.txt"
    )
  end
end
