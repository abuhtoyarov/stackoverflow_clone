require "rails_helper"

feature 'Authenticate user can answer to a question', %q{
  In order to help another person
  as a Authenticate user
  I want be able to create answer
  } do
    given(:question) { create(:question) }
    given(:answer) { create(:answer) }
    given(:user) { create(:user) }

    scenario 'Authenticate user try create regular answer with ajax', js: true do
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: answer.body
      click_on 'Post Your Answer'
      within('.answers') { expect(page).to have_content answer.body }
    end

    scenario 'Authenticate try create empty answer with ajax', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Post Your Answer'
      within('.answers') { expect(page).to_not have_content answer.body }
    end

    scenario 'Unauthtenticate user try create regular answer with ajax', js: true do
      visit question_path(question)
      fill_in 'Body', with: answer.body
      click_on 'Post Your Answer'
      within('.answers') { expect(page).to_not have_content answer.body }
    end
end
