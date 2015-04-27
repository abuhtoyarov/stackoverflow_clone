require "rails_helper"

feature 'User can delete attachments from question', %q{
  In order to fix mistake
  As an owner user
  I can delete file from question
}do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Question owner can delete attachment', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      click_on 'Edit'
      click_on 'Delete'
      click_on 'Submit'
      expect(page).to_not have_link 'file.txt'
    end
  end
end
