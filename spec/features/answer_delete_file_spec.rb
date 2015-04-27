require "rails_helper"

feature 'User can delete attachments from answer', %q{
  In order to fix mistake
  As an owner user
  I can delete file from answer
}do
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Answer owner can delete attachment', js: true do
    sign_in(user)
    visit question_path(answer.question)
    within "#answer#{answer.id}" do
      click_on 'Edit'
      click_on 'Delete'
      click_on 'Submit'
    end
    within '.answers' do
      expect(page).to_not have_link attachment.file.filename
    end
  end
end
