require 'rails_helper'

feature 'Authenticate user can edit question', %q{
    In order to correct mistakes
    as an question onwer
    I want be able to edit question
  } do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_question) { create(:question) }

  describe 'An authenticate user' do
    before :each do
      sign_in(user)
    end

    scenario 'try edit his own question', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'Edited! #{question.title}'
        fill_in 'Body', with: 'Edited! #{question.body}'
        click_on 'Submit'
        expect(page).to have_content 'Edited! #{question.title}'
        expect(page).to have_content 'Edited! #{question.body}'
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'input'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit link is active after update', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
        click_on 'Submit'
        click_on 'Edit'
        expect(page).to have_selector 'input'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'try edit another user question' do
      visit question_path(another_question)
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Guest user try edit question' do
    visit question_path(another_question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
