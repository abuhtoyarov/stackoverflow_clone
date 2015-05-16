require 'rails_helper'

feature 'Authenticate user can edit answer', %q{
    In order to correct mistakes
    as an answer onwer
    I want be able to edit answer
  } do
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user) }
  given(:another_answer) { create(:answer) }

  describe 'An authenticate user' do
    before :each do
      sign_in(user)
    end

    scenario 'try edit his own answer', js: true do
      visit question_path(answer.question)
      within ".answer#answer#{answer.id}" do
        click_on 'Edit'
        fill_in 'Body', with: 'Edited! #{answer.body}'
        click_on 'Submit'
      end
      within '.answers' do
        expect(page).to have_content 'Edited! #{answer.body}'
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit link is active after update', js: true do
      visit question_path(answer.question)
      within ".answer#answer#{answer.id}" do
        click_on 'Edit'
        click_on 'Submit'
        click_on 'Edit'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'try edit another user answer' do
      visit question_path(another_answer.question)
      within ".answer#answer#{another_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Guest user try edit answer' do
    visit question_path(another_answer.question)
    within ".answer#answer#{another_answer.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end
end
