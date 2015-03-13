FactoryGirl.define do
  factory :question do
    title "This is valid title with 15 symbol minimum"
    body  "Just a body"
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end

end
