FactoryGirl.define do
  sequence(:title) { |n| "This is valid title number #{n}" }
  sequence(:body) { |n| "Just a body number #{n}" }

  factory :question do
    title
    body
    user

    factory :invalid_question do
      title nil
      body nil
    end

    factory :question_with_answer do
      after :create do |question|
        create(:answer, question: question)
      end
    end

    factory :question_with_answers do
      after :create do |question|
        create_list :answer, 3, question: question
      end
    end

    factory :question_with_votes do
      after :create do |question|
        create_list :vote, 3, votable: question
      end
    end
  end
end
