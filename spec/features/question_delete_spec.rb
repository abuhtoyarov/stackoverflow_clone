require 'rails_helper'

feature 'Authenticate user can delete his own question' do
  given!(:user) { create(:user) }

  given(:question) { create(:question, user_id: user.id) }
  given(:question_with_answer) { create(:question_with_answer, user_id: user.id) }
  given(:another_user_question) { create(:question) }

  scenario 'Authenticate user try delete his own question without answers' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete Question'
    expect(page).to have_content 'Your question has been deleted'
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticate user try delete his own question with answers' do
    sign_in(user)
    visit question_path(question_with_answer)
    expect(page).to_not have_content 'Delete Question'
  end

  scenario 'Authenticate user try delete another user question' do
    sign_in(user)
    visit question_path(another_user_question)
    expect(page).to_not have_content 'Delete Question'
  end

  scenario 'Unauthenticate user try delete question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete Question'
  end
end
