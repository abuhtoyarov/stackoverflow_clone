require 'rails_helper'

feature 'User can create question', %q{
    In order to recive answers
    as an User
    I want be able ask question
  } do
    scenario 'User try create question with valid data'
    scenario 'User try create question with invalid data'
end