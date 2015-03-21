require 'rails_helper'

feature 'User can create question', %q{
    In order to recive answers
    as an User
    I want be able ask question
  } do
    given(:question) {create(:question)}
    before :each do
      visit '/questions'
      click_on  'Ask question'
    end
    scenario 'User try create question with valid data' do
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Create'
      expect(page).to have_content 'Your question successfully created'
    end

    scenario 'User try create question with invalid data' do
      click_on 'Create'
      expect(page).to have_content "Your question couldn't be submitted. Please see the errors:"
    end
end
