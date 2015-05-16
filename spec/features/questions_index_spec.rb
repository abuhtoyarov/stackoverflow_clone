require "rails_helper"

feature 'User can browse list of questions', %q{
  In order to look up questions
  As a User
  I want be able to browse list of questions
  } do
    scenario 'There are some questions with link' do
      questions = create_list(:question, 2)
      visit root_path
      expect(page).to have_content 'Top Questions'
      questions.each do |qst|
        expect(page).to have_content(qst.title)
      end
      click_link questions.first.title
      expect(page).to have_content(questions.first.title)
    end

    scenario 'There are no questions' do
      visit root_path
      expect(page).to have_content 'There are no questions. Ask something'
    end
  
end