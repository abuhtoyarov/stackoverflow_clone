require 'rails_helper'

feature 'Authenticate user can delete his own answer' do
  given(:another_user) { create(:user) }
  given!(:user) { create(:user) }
  
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user_id: user.id, question: question) }

  scenario 'Authenticate user try delete his own answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete Answer'
    expect(page).to have_content 'Your answer has been deleted'
  end

  scenario 'Authenticate user try delete another user answer' do
    sign_in(another_user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete Answer'
  end
  
  scenario 'Unauthenticate user try delete answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete Answer'
  end
end