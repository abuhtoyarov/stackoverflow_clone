$ -> 
  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe "/questions/#{questionId}/comments", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    parentIdentifier = "#{comment.parent}#{comment.parent_id}"
    content = JST["templates/comments/comment"]({comment: comment})
    $(".comments##{parentIdentifier}").append(content)
    $(".comment-create-form##{parentIdentifier}").hide()
    $(".comment-create-link##{parentIdentifier}").show()