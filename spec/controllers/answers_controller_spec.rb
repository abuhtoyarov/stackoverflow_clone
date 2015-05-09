require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer to database' do
        # this genereate expected request i.e.:
        # {:action=>"create", :answer=>{:body=>"MyString"},
        # :controller=>"answers", :question_id=>"193"}
        expect {
          post(
            :create,
            answer: attributes_for(:answer),
            question_id: question,
            format: 'json'
          )
        }.to change(question.answers, :count).by(1)
      end
      it 'show answers#create' do
        post(
          :create,
          answer: attributes_for(:answer),
          question_id: question,
          format: 'json'
        )
        expect(response.content_type).to eq('application/json')
      end
      it 'assign new answer to current user' do
        post(
          :create,
          answer: attributes_for(:answer),
          question_id: question,
          format: 'json'
        )
        expect(assigns(:answer).user).to be(subject.current_user)
      end
    end

    context 'with invalid attributes' do
      it 'dont save answer to database' do
        expect {
          post(
            :create,
            answer: attributes_for(:invalid_answer),
            question_id: question,
            format: 'json'
          )
        }.to_not change(Answer, :count)
      end
      it 'show answers#create' do
        post(
          :create,
          answer: attributes_for(:invalid_answer),
          question_id: question,
          format: 'json'
        )
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:answer) { create(:answer, question: question, user_id: @user.id) }

    context 'answers owner' do
      it 'delete answer from database' do
        expect { delete :destroy, id: answer, question_id: question, format: 'js' }
          .to change(Answer, :count).by(-1)
      end
    end

    context 'another auth user' do
      let!(:answer) { create(:answer, question: question) }

      it 'not delete answer from database' do
        expect { delete :destroy, id: answer, question_id: question, format: 'js' }
          .to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:new_answer) { build(:answer) }
    let(:antoher_user_answer) { create(:answer) }

    context 'auth user' do
      sign_in_user
      let!(:answer) { create(:answer, user_id: @user.id) }

      context 'answer owner' do
        it 'change answer attributes' do
          patch(
            :update,
            id: answer,
            answer: new_answer.attributes,
            question_id: answer.question,
            format: 'json'
          )
          answer.reload
          expect(answer.body).to eq new_answer.body
        end
      end

      context 'antoher user' do
        it 'not change answer attributes' do
          patch(
            :update,
            id: antoher_user_answer,
            answer: new_answer.attributes,
            question_id: antoher_user_answer.question,
            format: 'json'
          )
          antoher_user_answer.reload
          expect(antoher_user_answer.body).to_not eq new_answer.body
        end
      end
    end

    context 'unauth user' do
      it 'not change answer attributes' do
        patch(
          :update,
          id: answer,
          answer: new_answer.attributes,
          question_id: answer.question,
          format: 'json'
        )
        answer.reload
        expect(answer.body).to_not eq new_answer.body
      end
    end
  end

  describe 'patch #accept' do
    let(:antoher_question_answer) { create(:answer) }

    context 'auth user' do
      sign_in_user
      let!(:question) { create(:question, user_id: @user.id) }
      let!(:answer) { create(:answer, user_id: @user.id, question: question) }

      context 'question owner' do
        it 'change answer attribute accepted' do
          patch(
            :accept,
            id: answer,
            question_id: answer.question,
            format: 'js'
          )
          answer.reload
          expect(answer.accepted?).to eq true
        end
      end

      context 'another user' do
        it 'not change answer attribute accepted' do
          patch(
            :accept,
            id: antoher_question_answer,
            question_id: antoher_question_answer.question,
            format: 'js'
          )
          antoher_question_answer.reload
          expect(antoher_question_answer.accepted?).to eq false
        end
      end
    end

    context 'unauth user' do
      it 'not change answer attribute' do
        patch(
          :accept,
          id: answer,
          question_id: answer.question,
          format: 'js'
        )
        answer.reload
        expect(answer.accepted?).to eq false
      end
    end
  end

  describe 'PATCH #vote_up' do
    context 'auth user' do
      sign_in_user
      let!(:user_answer) { create(:answer, user_id: @user.id) }

      context 'another user answer' do
        it 'increase answer votes' do
          expect {
            patch :vote_up,
            id: answer,
            question_id: answer.question,
            format: :json
          }.to change(answer.votes, :count).by(1)
        end
      end
      context 'user answer' do
        it 'not change votes' do
          expect {
            patch :vote_up,
            id: user_answer,
            question_id: answer.question,
            format: :json
          }.to_not change(answer.votes, :count)
        end
      end
    end

    context 'unauth user' do
      it 'not change votes' do
        expect {
          patch :vote_up,
          id: answer,
          question_id: answer.question,
          format: :json
        }.to_not change(answer.votes, :count)
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'auth user' do
      sign_in_user
      let!(:user_answer) { create(:answer, user_id: @user.id) }

      context 'another user answer' do
        it 'decrease answer votes' do
          expect {
            patch :vote_down,
            id: answer,
            question_id: answer.question,
            format: :json
          }.to change(answer.votes, :count).by(1)
        end
      end
      context 'user answer' do
        it 'not change votes' do
          expect {
            patch :vote_down,
            id: user_answer,
            question_id: answer.question,
            format: :json
          }.to_not change(answer.votes, :count)
        end
      end
    end

    context 'unauth user' do
      it 'not change votes' do
        expect {
          patch :vote_down,
          id: answer,
          question_id: answer.question,
          format: :json
        }.to_not change(answer.votes, :count)
      end
    end
  end

  describe 'PATCH #unvote' do
    context 'auth user' do
      sign_in_user
      let!(:answer) { create(:answer) }
      let!(:vote) { create(:vote, user_id: @user.id, votable: answer) }
      context 'another user answer' do
        it 'decrease answer votes' do
          expect {
            patch :unvote,
            id: answer,
            question_id: answer.question,
            format: :json
          }.to change(answer.votes, :count).by(-1)
        end
      end
    end

    context 'unauth user' do
      let(:vote) { create(:vote, answer: answer) }
      it 'not change votes' do
        expect { patch :unvote,
          id: answer,
          question_id: answer.question,
          format: :json
        }.to_not change(answer.votes, :count)
      end
    end
  end
end
