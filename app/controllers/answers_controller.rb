class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  before_action :find_answer, only: [:update, :destroy, :accept]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.html { render @answer }
        format.json { render json: @answer }
      else
        format.html { render text: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(answer_params) if current_user.owner?(@answer)
  end

  def destroy
    @answer.destroy! if current_user.owner?(@answer)
  end

  def accept
    @answer.accept if current_user.id == @question.user_id
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
end
