require "rails_helper"

feature 'Authenticate user can answer to a question', %q{
  In order to help another person
  as a Authenticate user
  I want be able to create answer
  } do
    given(:question) { create(:question) }
    given(:answer) { create(:answer) }
    given(:user) { create(:user) }



    scenario 'Authenticate user try create regular answer' do
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: answer.body
      click_on 'Post Your Answer'
      expect(page).to have_content 'Your answer successfully created'
      expect(page).to have_content answer.body
    end

    scenario 'Authenticate try create empty answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Post Your Answer'
      expect(page).to have_content(
        "Your answer couldn't be submitted. Please see the errors:"
      )
    end

    scenario 'Unauthtenticate user try create regular answer' do
      visit question_path(question)
      fill_in 'Body', with: answer.body
      click_on 'Post Your Answer'
      expect(page).to have_content(
        'You need to sign in or sign up before continuing.'
      )
    end
end
