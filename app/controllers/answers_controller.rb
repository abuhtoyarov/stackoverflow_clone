class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_question
  before_action :find_answer, except: [:create]
  before_action :user_authorized?, only: [:update, :destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.html { render @answer }
        format.json { render @answer }
      else
        format.html { render @answer }
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.json { render @answer }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @answer.destroy!
  end

  def accept
    @answer.accept if current_user.owner?(@question)
    @answers = @question.answers.by_rating
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = @question.answers.find(params[:id])
  end

  def user_authorized?
    return if current_user.owner?(@answer)
    flash[:error] = 'Permission denied'
    redirect_to root_path
  end
end
