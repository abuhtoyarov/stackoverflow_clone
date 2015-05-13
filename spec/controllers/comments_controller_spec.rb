require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create :answer }
  let(:comment) { create :comment }

  describe 'POST#create' do
    sign_in_user
    describe 'questions comment' do
      context 'with valid attributes' do
        it 'saves a new comment to the database' do
          expect {
            post(
              :create,
              comment: attributes_for(:comment),
              question_id: question,
              format: :js
            )
          }.to change(question.comments, :count).by(1)
        end

        it 'response js' do
          post(
            :create,
            comment: attributes_for(:comment),
            question_id: question,
            format: :js
          )
          expect(response.content_type).to eq('text/javascript')
        end
      end

      context 'with invalid attributes' do
        it 'does not save a new comment to the database' do
          expect {
            post(
              :create,
              comment: attributes_for(:invalid_comment),
              question_id: question,
              format: :js
            )
          }.not_to change(Comment, :count)
        end

        it 'renders unprocessable entity' do
          post(
            :create,
            comment: attributes_for(:invalid_comment),
            question_id: question,
            format: :js
          )
          expect(response.content_type).to eq('text/javascript')
        end
      end
    end

    describe 'answers comment' do
      context 'with valid attributes' do
        it 'saves a new comment to the database' do
          expect {
            post(
              :create,
              comment: attributes_for(:comment),
              answer_id: answer,
              format: :js
            )
          }.to change(answer.comments, :count).by(1)
        end

        it 'response js' do
          post(
            :create,
            comment: attributes_for(:comment),
            answer_id: answer,
            format: :js
          )
          expect(response.content_type).to eq('text/javascript')
        end
      end

      context 'with invalid attributes' do
        it 'does not save a new comment to the database' do
          expect {
            post(
              :create,
              comment: attributes_for(:invalid_comment),
              answer_id: answer,
              format: :js
            )
          }.not_to change(Comment, :count)
        end

        it 'renders unprocessable entity' do
          post(
            :create,
            comment: attributes_for(:invalid_comment),
            answer_id: answer,
            format: :js
          )
          expect(response.content_type).to eq('text/javascript')
        end
      end
    end
  end
end
