FactoryGirl.define do
  factory :answer do
    question
    user
    body

    factory :invalid_answer do
      body nil
    end

    factory :answer_with_votes do
      after :create do |answer|
        create_list :vote, 3, votable: answer
      end
    end
  end
end
