FactoryGirl.define do
  factory :comment do
    body "MyString"
    user

    factory :invalid_comment do
      body nil
    end
  end
end
