class QuestionsController < ApplicationController
  before_action :find_question, only: [:show, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def destroy
    if current_user.id == @question.user_id && @question.answers.count == 0
      @question.destroy!
      flash[:notice] = 'Your question has been deleted'
      redirect_to questions_path
    else
      flash[:error] = 'Permission denied'
      redirect_to question_path(@question)
    end
  end


  private
    def find_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body)
    end
end
