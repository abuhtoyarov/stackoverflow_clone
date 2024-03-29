require "rails_helper"

feature 'User can sign in', %q{
  In order to be able to ask questions
  as an user
  I want to be able to sign in
  } do
  given(:user) { create(:user) }

  scenario 'Existing user try to sign in' do
    sign_in(user)
    expect(page).to have_content "Signed in successfully."
  end

  scenario 'Unexistign user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'some@email.com'
    fill_in 'Password', with: 'safas23452jskg'
    click_on 'Log in'

    expect(page).to have_content "Invalid email or password."
  end
end
