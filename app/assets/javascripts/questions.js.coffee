ready = ->
  # show form for question
  $('.edit-question-link').click ->
    $(this).hide()
    $('.question-edit-form').show()

  # show form for answer
  $('.edit-answer-link').click ->
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('#answer' + answer_id).find('.answer-edit-form').show()

vote = (e, data, status, xhr) ->
  votes = $.parseJSON(xhr.responseText)
  $('.votes').replaceWith(JST["templates/votes"]({votes: votes}))
voteError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.votes-error').append(value)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('ajax:success', '.votes', vote)
$(document).on('ajax:error', '.votes', voteError)

