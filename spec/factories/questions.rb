FactoryGirl.define do
  factory :question do
    title "This is valid title with 15 symbol minimum"
    body  "Just a body"

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
