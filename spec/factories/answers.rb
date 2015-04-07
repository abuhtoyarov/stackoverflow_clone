FactoryGirl.define do
  factory :answer do
    question
    user
    body

    factory :invalid_answer do
      body nil
    end
  end
end
