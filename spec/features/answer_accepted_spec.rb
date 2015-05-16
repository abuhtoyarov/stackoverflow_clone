require 'rails_helper'

feature 'User can accept answer', %q{
  In order to show answer that helped
  As a question owner
  I can accept answer
  } do
  given!(:user) { create(:user) }

  given!(:question) { create(:question_with_answers, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given(:another_user_question) { create(:question) }

  scenario 'Authenticate user try accept answer within his question', js: true do
    sign_in(user)
    visit question_path(question)
    within(".answer#answer#{answer.id}") { click_on 'Accept answer' }
    sleep(1)
    within(first('.answer')) do
      expect(page).to have_content answer.body
      expect(page).to have_content 'accepted'
    end
  end

  scenario 'Authenticate user try accept answer within another user question' do
    sign_in(user)
    visit question_path(another_user_question)
    expect(page).to_not have_content 'Accept answer'
  end

  scenario 'Unauthenticate user try accept answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Accept answer'
  end
end
