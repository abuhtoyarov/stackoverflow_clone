require 'rails_helper'

feature 'Authenticate user can create question', %q{
    In order to recive answers
    as an registered user
    I want be able ask question
  } do
  given(:question) { build(:question) }
  given(:user) { create(:user) }

  before :each do
    sign_in(user)
    visit '/questions'
    click_on 'Ask question'
  end

  scenario 'Authenticate user try create question with valid data' do
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'
    expect(page).to have_content 'Question was successfully created'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Authenticate user try create question with invalid data' do
    click_on 'Create'
    expect(page).to have_content(
      "Your question couldn't be submitted. Please see the errors:"
    )
  end

  scenario 'Unauthenticate user try create question' do
    sign_out
    visit '/questions'
    click_on 'Ask question'
    expect(page).to have_content(
      'You are not authorized to access this page'
    )
  end
end
