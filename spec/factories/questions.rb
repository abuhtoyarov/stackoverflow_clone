FactoryGirl.define do
  sequence :title do |seq|
    "This is valid title number #{seq}"
  end

  factory :question do
    title
    body  "Just a body"
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

  end

end
