class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  before_action :find_answer, only: [:update, :destroy, :update_accepted]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if user_is_owner?
  end

  def destroy
    # TODO: add flash errors. remove bang
    @answer.destroy! if user_is_owner?
  end

  def update_accepted
    @answer.accept if current_user.id == @question.user_id
    @answers = @answer.question.answers
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = @question.answers.find(params[:id])
  end

  def user_is_owner?
    current_user.id == @answer.user_id
  end
end
