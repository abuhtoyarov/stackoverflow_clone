require 'rails_helper'

feature 'Registered user can create question', %q{
    In order to recive answers
    as an registered user
    I want be able ask question
  } do
    given(:question) {create(:question)}
    before :each do
      visit '/questions'
      click_on  'Ask question'
    end
    scenario 'Registered user try create question with valid data' do
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Create'
      expect(page).to have_content 'Your question successfully created'
    end

    scenario 'Registered user try create question with invalid data' do
      click_on 'Create'
      expect(page).to have_content(
        "Your question couldn't be submitted. Please see the errors:"
      )
    end

    scenario 'Unregistered user try create question with valid data'
end
