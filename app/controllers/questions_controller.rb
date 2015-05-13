class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, except: [:index, :new, :create]
  before_action :auth_user_vote, only: [:vote_up, :vote_down]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      PrivatePub.publish_to "/questions", question: @question.to_json
      flash[:notice] = 'Your question successfully created.'
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def update
    @question.update!(question_params) if current_user.owner?(@question)
  end

  def destroy
    if current_user.owner?(@question) && @question.answers.empty?
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
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
