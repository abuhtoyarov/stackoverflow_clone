require "rails_helper"
  
  feature 'User can sign up' do

    given(:user) { build(:user) }
    given(:registered_user) { create(:user) }
    scenario 'User sign up with valid data' do
      sign_up(user)
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'User sign up with already registered email' do
      sign_up(registered_user)
      expect(page).to have_content 'Email has already been taken'
    end
    
  end