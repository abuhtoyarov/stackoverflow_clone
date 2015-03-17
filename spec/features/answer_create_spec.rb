require "rails_helper"

feature 'User can answer to a question', %w{
  In order to help another person
  as a User
  I want be able to create answer
  } do
    scenario 'User try create empty answer'
    scenario 'User try create regular answer'
  
end