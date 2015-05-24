class CommentsController < ApplicationController
  before_action :find_resource
  after_action :pub_comments

  respond_to :js

  authorize_resource

  def create
    @comment = @resource.comments.create(comment_params.merge(user_id: current_user.id))
    respond_with(@comment)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def pub_comments
    return unless @comment.valid?
    PrivatePub.publish_to(
      "/questions/#{@resource.try(:question).try(:id) || @resource.id}/comments",
      comment: render_to_string(template: 'comments/comment.json.jbuilder')
    )
  end

  def find_resource
    params.each do |name, value|
      @resource = name[0..-3].classify.constantize.find(value) if /(.+)_id$/.match(name)
    end
  end
end
