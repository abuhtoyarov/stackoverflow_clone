FactoryGirl.define do
  factory :question do
    title "This is valid title with 15 symbol minimum"
    body  "Just a body"

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
