require 'rails_helper'

feature 'Authenticate user can edit question', %q{
    In order to correct mistakes
    as an question onwer
    I want be able to edit question
  } do
  given(:question) { build(:question) }
  given(:user) { create(:user) }

  describe 'An authenticate user' do
    scenario 'try edit his own question'
    scenario 'try edit another user question'
  end

  scenario 'Guest user try edit question'
end
