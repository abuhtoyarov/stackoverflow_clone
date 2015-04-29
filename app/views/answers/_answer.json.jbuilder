json.extract! @answer, :id, :body
json.user @answer.user, :id
json.current_user_id current_user.id
json.path url_for([@question, @answer])

json.attachments @answer.attachments do |att|
  json.id att.id
  json.filename att.file.filename
  json.url att.file.url
end