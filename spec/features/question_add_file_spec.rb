require "rails_helper"

feature 'User can attach file to question', %q{
    In order to ask more clearly
    As a User
    I can attach file to question
  } do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:file) { "#{Rails.root}/spec/fixtures/file.txt" }

  before do
    sign_in(user)
    visit '/questions'
    click_on 'Ask question'
  end

  scenario 'Auth user attach file to question' do
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    attach_file 'File', file
    click_on 'Create'
    expect(page).to have_link 'file.txt', href: "/uploads/attachment/file/1/file.txt"
  end
end
