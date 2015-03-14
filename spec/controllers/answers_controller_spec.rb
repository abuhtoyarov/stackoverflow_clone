require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer to database' do
        # this genereate expected request i.e.:
        # {:action=>"create", :answer=>{:body=>"MyString"},
        # :controller=>"answers", :question_id=>"193"}
        expect { 
              post :create, 
                answer: attributes_for(:answer), 
                question_id: question 
            }.to change(question.answers, :count).by(1)
      end
      it 'redirect to question #show' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to(question)
      end
    end

    context 'with invalid attributes' do
      it 'dont save answer to database' do
        expect { 
            post :create, 
              answer: attributes_for(:invalid_answer), 
              question_id: question 
          }.to_not change(question.answers, :count)
      end
      it 'redirect_to question #show' do
        post :create, 
          answer: attributes_for(:invalid_answer), 
          question_id: question
        expect(response).to redirect_to(question)
      end
    end
  end
end
