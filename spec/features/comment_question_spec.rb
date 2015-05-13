require 'rails_helper'

feature 'Authenticate user can comment a question', %q{
  In order to specify a question
  as an Authenticate user
  I want be able to comment a question
} do
  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given(:comment) { create :comment }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates a comment', js: true do
      within '.question' do
        click_on 'add a comment'
        fill_in 'comment', with: comment.body
        click_on 'Submit'
        expect(page).to have_content comment.body
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'can not comment a question' do
      within '.question' do
        expect(page).not_to have_link 'add a comment'
      end
    end
  end
end
