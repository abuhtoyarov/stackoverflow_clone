class AnswersController < ApplicationController
before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      flash[:notice] = 'Your answer successfully created'
      redirect_to @question
    else
      #render DONT execute any code in the action so we need to assign @answers
      @answers = @question.answers.reset
      render 'questions/show'
    end
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    if current_user.id == @answer.user_id
      @answer.destroy!
      flash[:notice] = 'Your answer has been deleted'
    else
      flash[:error] = 'Permission denied'
    end
      redirect_to @question
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end
