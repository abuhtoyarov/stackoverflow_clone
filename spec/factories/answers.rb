FactoryGirl.define do
  factory :answer do
    question
    body "MyString"

    factory :invalid_answer do
      body nil
    end
  end

end
