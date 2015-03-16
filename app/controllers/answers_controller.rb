class AnswersController < ApplicationController

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    if @answer.save
      redirect_to @question
    else
      #render DONT execute any code in the action so we need to assign @answers
      @answers = @question.answers.reset
      render 'questions/show'
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end
