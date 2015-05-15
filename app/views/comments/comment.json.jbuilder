json.extract! @comment, :id, :body
json.user_email @comment.user.email
json.parent @resource.class.name.downcase
json.parent_id @resource.id