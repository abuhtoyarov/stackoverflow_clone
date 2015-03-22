require 'rails_helper'

feature 'Authenticate user can delete his own question' do
  scenario 'Authenticate user try delete his own question'
  scenario 'Authenticate user try delete another user question'
  scenario 'Unauthenticate user try delete question'
end