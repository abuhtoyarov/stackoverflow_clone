class AnswersController < ApplicationController
  include Voted

  # before_action :authenticate_user!
  before_action :find_answer, except: [:create]
  before_action :find_question, only: [:create, :accept]
  # before_action :user_authorized?, only: [:update, :destroy]
  # before_action :user_owner_question?, only: [:accept]
  after_action :pub_answer, only: :create
  respond_to :js, :json

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    respond_with(@answer.update!(answer_params), template: 'answers/_answer.json.jbuilder')
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def accept
    @answer.accept
    @answers = @question.answers.by_rating
    respond_with(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def find_question
    @question = params.has_key?(:question_id) ? Question.find(params[:question_id]) : @answer.question
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def pub_answer
    return unless @answer.valid?
    PrivatePub.publish_to "/questions/#{@question.id}/answers",
                          answer: render_to_string(template: 'answers/_answer.json.jbuilder')
  end

  def user_authorized?
    return if current_user.owner?(@answer)
    flash[:error] = 'Permission denied'
    redirect_to root_path
  end

  def user_owner_question?
    return if current_user.owner?(@question)
    flash[:error] = "Permission denied"
    redirect_to root_path
  end
end
