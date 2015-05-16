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
  given(:file_two) { "#{Rails.root}/spec/fixtures/file2.txt" }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Auth user attach file to answer', js: true do
    fill_in 'Body', with: answer.body
    click_on 'Add file'
    attach_file 'File', file
    click_on 'Post Your Answer'
    within '.answers' do
      expect(page).to have_link 'file.txt', href: "/uploads/attachment/file/1/file.txt"
    end
  end

  scenario 'Auth user attach several files to answer', js: true do
    fill_in 'Body', with: answer.body
    click_on 'Add file'
    click_on 'Add file'
    inputs = page.all('input[type="file"]')
    inputs[0].set file
    inputs[1].set file_two
    click_on 'Post Your Answer'
    within '.answers' do
      expect(page).to have_link 'file.txt', href: "/uploads/attachment/file/1/file.txt"
      expect(page).to have_link 'file2.txt', href: "/uploads/attachment/file/2/file2.txt"
    end
  end
end
