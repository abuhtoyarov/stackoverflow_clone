require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  # Can call 'question' method to assigns :question
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #index' do
    before { get :index }
    it 'populates an array of questions' do
      expect(assigns(:questions)).to match_array [question]
    end
    it 'renders :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'assigns the new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'assigns new Attachment to nested attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
    it 'populates an array of answers' do
      expect(assigns(:answers)).to match_array [answer]
    end
    it 'renders :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns new Attachment to nested attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders :new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    # Passing factory girls attributes_for
    # this attributes must be in question: hash for strong params
    context 'with valid attributes' do
      it 'saves the new question to database' do
        expect { post :create, question: attributes_for(:question) }.
          to change(Question, :count).by(1)
      end
      it 'redirect to question#show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end
      it 'assign new question to current user' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user).to be(subject.current_user)
      end
    end

    context 'with invalid attributes' do
      it 'dont saves new question to database' do
        expect { post :create, question: attributes_for(:invalid_question) }.
          to_not change(Question, :count)
      end
      it 'redirect to question#new' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:question_with_answer) { create(:question_with_answer, user_id: @user.id) }
    let!(:question) { create(:question, user_id: @user.id) }
    let!(:another_user_question) { create(:question) }

    context 'question owner' do
      it 'delete question from database' do
        expect { delete :destroy, id: question }.
          to change(Question, :count).by(-1)
      end
      it 'redirect to questions index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'question with answers owner' do
      it 'not delete question from database' do
        expect { delete :destroy, id: question_with_answer }.
          to_not change(Question, :count)
      end
      it 'redirect to question' do
        delete :destroy, id: question_with_answer
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'another user question' do
      it 'not delete question from database' do
        expect { delete :destroy, id: another_user_question }.
          to_not change(Question, :count)
      end

      it 'redirect to question' do
        delete :destroy, id: another_user_question
        expect(response).to redirect_to assigns(:question)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:new_question) { build(:question) }
    let!(:another_user_question) { create(:question) }

    context 'auth user' do
      sign_in_user
      let!(:question) { create(:question, user_id: @user.id) }

      context 'question owner' do
        it 'change question attributes' do
          patch :update, id: question, question: new_question.attributes, format: :js
          question.reload
          expect(question.title).to eq new_question.title
          expect(question.body).to eq new_question.body
        end
      end

      context 'another user question' do
        it 'not change question attributes' do
          patch :update, id: another_user_question, question: new_question.attributes, format: :js
          another_user_question.reload
          expect(another_user_question.title).to_not eq new_question.title
          expect(another_user_question.body).to_not eq new_question.body
        end
      end
    end

    context 'unauth user' do
      it 'not change question attributes' do
        patch :update, id: question, question: new_question.attributes, format: :js
        question.reload
        expect(question.title).to_not eq new_question.title
        expect(question.body).to_not eq new_question.body
      end
    end
  end

  describe 'PATCH #voteup' do
    context 'auth user' do
      sign_in_user
      let!(:user_question) { create(:question, user_id: @user.id) }

      context 'another user question' do
        it 'increase question votes' do
          expect {
            patch :voteup,
            id: question,
            format: :json
          }.to change(question.votes, :count).by(1)
        end
      end
      context 'user question' do
        it 'not change votes' do
          expect {
            patch :voteup,
            id: user_question,
            format: :json
          }.to_not change(question.votes, :count)
        end
      end
    end

    context 'unauth user' do
      it 'not change votes' do
        expect {
          patch :voteup,
          id: question,
          format: :json
        }.to_not change(question.votes, :count)
      end
    end
  end

  describe 'PATCH #votedown' do
    context 'auth user' do
      sign_in_user
      let!(:user_question) { create(:question, user_id: @user.id) }

      context 'another user question' do
        it 'decrease question votes' do
          expect {
            patch :votedown,
            id: question,
            format: :json
          }.to change(question.votes, :count).by(1)
        end
      end
      context 'user question' do
        it 'not change votes' do
          expect {
            patch :votedown,
            id: user_question,
            format: :json
          }.to_not change(question.votes, :count)
        end
      end
    end

    context 'unauth user' do
      it 'not change votes' do
        expect {
          patch :votedown,
          id: question,
          format: :json
        }.to_not change(question.votes, :count)
      end
    end
  end

  describe 'PATCH #unvote' do
    context 'auth user' do
      sign_in_user
      let!(:question) { create(:question) }
      let!(:vote) { create(:vote, user_id: @user.id, votable: question) }
      context 'another user question' do
        it 'decrease question votes' do
          expect {
            patch :unvote,
            id: question,
            format: :json
          }.to change(question.votes, :count).by(-1)
        end
      end
    end

    context 'unauth user' do
      let(:vote) { create(:vote, question: question) }
      it 'not change votes' do
        expect { patch :unvote,
          id: question,
          format: :json
        }.to_not change(question.votes, :count)
      end
    end
  end
end
