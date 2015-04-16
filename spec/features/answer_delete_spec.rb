require 'rails_helper'

feature 'Authenticate user can delete his own answer' do
  given(:another_user) { create(:user) }
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user) }

  scenario 'Authenticate user try delete his own answer with ajax', js: true do
    sign_in(user)
    visit question_path(answer.question)
    click_on 'Delete Answer'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticate user try delete another user answer' do
    sign_in(another_user)
    visit question_path(answer.question)
    expect(page).to_not have_content 'Delete Answer'
  end

  scenario 'Unauthenticate user try delete answer' do
    visit question_path(answer.question)
    expect(page).to_not have_content 'Delete Answer'
  end
end
