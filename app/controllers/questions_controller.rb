class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :find_question, only: [:show, :destroy, :update]

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
    @question.user = current_user

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if user_is_owner?
  end

  def destroy
    if user_is_owner? && @question.answers.empty?
      @question.destroy!
      flash[:notice] = 'Your question has been deleted'
      redirect_to questions_path
    else
      flash[:error] = 'Permission denied'
      redirect_to question_path(@question)
    end
  end

  private

  def user_is_owner?
    current_user.id == @question.user_id
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
