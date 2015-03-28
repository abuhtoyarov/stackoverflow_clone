require "rails_helper"

feature 'User can sign out' do

  given(:user) { create(:user) }
  scenario 'Authenticated user can sign out' do
    sign_in(user)
    sign_out
    expect(page).to have_content 'Signed out successfully.'
  end
end