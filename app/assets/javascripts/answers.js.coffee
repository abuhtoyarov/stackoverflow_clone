# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    content = JST["templates/answers/answer"]({answer: answer})
    $("#answer#{answer.id}").replaceWith(content)
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answers-error').append(value)

  createNewAnswerChannel()

createNewAnswerChannel = ->
  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    answer = $.parseJSON(data['answer'])
    content = JST["templates/answers/answer"]({answer: answer})
    $('.answers').append(content)

vote = (e, data, status, xhr) ->
  votes = $.parseJSON(xhr.responseText)
  $("#answer#{votes.resource_id} .votes").replaceWith(JST["templates/votes"]({votes: votes}))
voteError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $("#answer#{votes.resource_id} .votes-error").append(value)

$(document).on('ajax:success', '.answers .votes', vote)
$(document).on('ajax:error', '.answers .votes', voteError)