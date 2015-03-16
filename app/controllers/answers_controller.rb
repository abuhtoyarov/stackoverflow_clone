class AnswersController < ApplicationController

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    if @answer.save
      redirect_to @question
    else
      redirect_to controller: 'questions', 
        action: 'show', 
        id: @question.id,
        answer: answer_params
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end
