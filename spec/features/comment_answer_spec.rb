require 'rails_helper'

feature 'Authenticate user can comment a answer', %q{
  In order to specify an answer
  as an Authenticate user
  I want be able to comment a answer
} do
  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:answer) { create :answer, user: user, question: question }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates a comment', js: true do
      within "#answer#{answer.id}" do
        click_on 'add a comment'
        fill_in 'comment', with: comment.body
        click_on 'Submit'
        expect(page).to have_content comment.body
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'can not comment a answer' do
      within "#answer#{answer.id}" do
        expect(page).not_to have_link 'add a comment'
      end
    end
  end
end
