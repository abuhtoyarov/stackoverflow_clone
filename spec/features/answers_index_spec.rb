require "rails_helper"

feature 'User can browse question with its answers', %q{
    In order to look up answers for interesting question
    As a User
    I can browse question page
  } do
    given(:question_with_answer) { create(:question_with_answer) }
    given(:question) { create(:question)}
    scenario 'User open question with answers' do
      visit question_path(question_with_answer)
      expect(page).to have_content(question_with_answer.title)
      expect(page).to have_content(question_with_answer.body)
      question_with_answer.answers.each do |answ|
        expect(page).to have_content(answ.body)
      end
    end

    scenario 'User open question without answers' do 
      visit question_path(question)
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
      expect(page).to have_content 'Know an answer? Please post it'
    end
  
end