require "rails_helper"

feature 'Registered user can answer to a question', %q{
  In order to help another person
  as a Registered user
  I want be able to create answer
  } do
    given(:question) { create(:question) }
    given(:answer) { create(:answer) }

    scenario 'Registered user try create regular answer' do
      visit question_path(question)
      fill_in 'Body', with: answer.body
      click_on 'Post Your Answer'
      expect(page).to have_content 'Your answer successfully created'
    end

    scenario 'Registered try create empty answer' do
      visit question_path(question)
      click_on 'Post Your Answer'
      expect(page).to have_content(
        "Your answer couldn't be submitted. Please see the errors:"
      )
    end

    scenario 'Unregistered user try create regular answer'
end
