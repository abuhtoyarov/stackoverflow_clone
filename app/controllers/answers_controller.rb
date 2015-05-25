class AnswersController < ApplicationController
  include Voted

  before_action :find_answer, except: [:create]
  before_action :find_question, only: [:create, :accept]
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
    @question = params.has_key?(:question_id) ? Question.find_by(id: params[:question_id]) : @answer.question
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def pub_answer
    return unless @answer.valid?
    PrivatePub.publish_to "/questions/#{@question.id}/answers",
                          answer: render_to_string(template: 'answers/_answer.json.jbuilder')
  end
end
