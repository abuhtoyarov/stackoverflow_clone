require 'rails_helper'

feature 'Authenticate user can vote answer', %q{
    In order to choose useful answer
    as an user
    I want be able to vote answer
  } do
  given!(:user) { create(:user) }
  given!(:user_answer) { create(:answer, user: user) }
  given(:answer) { create(:answer) }
  given(:another_user) { create(:user) }

  describe 'An authenticate user' do
    before :each do
      sign_in(user)
    end

    scenario 'try to vote up another user answer', js: true do
      visit question_path(answer.question)
      within "#answer#{answer.id}" do
        click_on 'Vote up'
        within '.score' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'try to vote down another user answer', js: true do
      visit question_path(answer.question)
      within "#answer#{answer.id}" do
        click_on 'Vote down'
        within '.score' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'try to vote up another user answer twice', js: true do
      visit question_path(answer.question)
      within "#answer#{answer.id}" do
        click_on 'Vote up'
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
      end
    end

    scenario 'try to unvote and vote ones more', js: true do
      visit question_path(answer.question)
      within "#answer#{answer.id}" do
        click_on 'Vote up'
        click_on 'Unvote'
        click_on 'Vote down'
        within '.score' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'try to vote up his own answer', js: true do
      visit question_path(user_answer.question)
      within "#answer#{user_answer.id}" do
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
      end
    end

    scenario 'sees correct score after vote', js: true do
      visit question_path(answer.question)
      within "#answer#{answer.id}" do
        click_on 'Vote up'
      end
      click_on 'Sign Out'
      sign_in(another_user)
      visit question_path(answer.question)
      within "#answer#{answer.id}" do
        click_on 'Vote up'
        within '.score' do
          expect(page).to have_content '2'
        end
      end
    end
  end

  scenario 'Guest user try vote up answer', js: true do
    visit question_path(answer.question)
    within "#answer#{answer.id}" do
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
    end
  end
end
