require "rails_helper"

feature 'User can attach file to answer', %q{
    In order to answer more clearly
    As a User
    I can attach file to answer
  } do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }
  given(:file) { "#{Rails.root}/spec/fixtures/file.txt" }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Auth user attach file to answer', js: true do
    fill_in 'Body', with: answer.body
    attach_file 'File', file
    click_on 'Post Your Answer'
    within '.answers' do
      expect(page).to have_link 'file.txt', href: "/uploads/attachment/file/1/file.txt"
    end
  end
end
