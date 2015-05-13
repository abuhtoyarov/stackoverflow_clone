class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      format.js do
        if @comment.save
          PrivatePub.publish_to 
            "/#{@resource.class.name.downcase}s/#{@resource.id}/comments",
            comment: render (template: 'comment/_comment.json.jbuilder')
        else
          render :error
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_resource
    params.each do |name, value|
      @resource = name.classify.constantize.find(value) if /(.+)_id$/.match(name)
    end
  end
end
