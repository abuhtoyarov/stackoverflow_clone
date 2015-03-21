require "rails_helper"

feature 'User can sign in', %q{
  In order to be able to ask questions
  as an user
  I want to be able to sign in
  } do
    scenario 'Existing user try to sign in'
    scenario 'Unexistign user try to sign in'
  
end