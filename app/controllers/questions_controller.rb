class QuestionsController < ApplicationController
  before_action :find_question, only: :show

  def show
  end

  def new
    @question = Question.new
  end

  private
    def find_question
      @question = Question.find(params[:id])
    end
end
