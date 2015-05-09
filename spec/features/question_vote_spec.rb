require 'rails_helper'

feature 'Authenticate user can vote question', %q{
    In order to choose useful question
    as an user
    I want be able to vote question
  } do
  given!(:user) { create(:user) }
  given!(:user_question) { create(:question, user: user) }
  given(:question) { create(:question) }
  given(:another_user) { create(:user) }

  describe 'An authenticate user' do
    before :each do
      sign_in(user)
    end

    scenario 'try to vote up another user question', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Vote up'
        within '.score' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'try to vote down another user question', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Vote down'
        within '.score' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'try to vote up another user question twice', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Vote up'
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
      end
    end

    scenario 'try to unvote and vote ones more', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Vote up'
        click_on 'Unvote'
        click_on 'Vote down'
        within '.score' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'try to vote up his own question', js: true do
      visit question_path(user_question)
      within '.question' do
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
      end
    end

    scenario 'sees correct score after vote', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Vote up'
      end
      click_on 'Sign Out'
      sign_in(another_user)
      visit question_path(question)
      within '.question' do
        click_on 'Vote up'
        within '.score' do
          expect(page).to have_content '2'
        end
      end
    end
  end

  scenario 'Guest user try vote up question', js: true do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
    end
  end
end
