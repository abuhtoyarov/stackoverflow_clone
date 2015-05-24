class QuestionsController < ApplicationController
  include Voted

  before_action :find_question, except: [:index, :new, :create]
  before_action :build_answer, only: :show
  after_action :pub_question, only: :create

  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    respond_with(@question.update!(question_params))
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = Answer.new
  end

  def pub_question
    PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
