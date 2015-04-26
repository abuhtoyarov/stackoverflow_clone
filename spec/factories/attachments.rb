FactoryGirl.define do
  factory :attachment do
    file { File.new("#{Rails.root}/spec/fixtures/file.txt") }
  end
end
