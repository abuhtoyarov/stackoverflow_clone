require 'rails_helper'

feature 'Authenticate user can delete his own answer' do
  scenario 'Authenticate user try delete his own answer'
  scenario 'Authenticate user try delete another user answer'
  scenario 'Unauthenticate user try delete answer'
end