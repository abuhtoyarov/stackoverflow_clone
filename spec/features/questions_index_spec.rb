require "rails_helper"

feature 'User can browse list of questions', %q{
  In order to look up questions
  As a User
  I want be able to browse list of questions
  } do
    scenario 'There are some questions' do
      question = create(:question)
      visit root_path
      expect(page).to have_content 'Top Questions'
      expect(page).to have_content question.title
    end

    scenario 'There are not questions' do
      visit root_path
      expect(page).to have_content 'There are not questions. Ask something'
    end
  
end