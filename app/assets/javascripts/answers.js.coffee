# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append(JST["templates/answers/answer"]({answer: answer}))
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answers-error').append(value)

  $('form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $("#answer#{answer.id}").replaceWith(JST["templates/answers/answer"]({answer: answer}))
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-error-edit').append(value)

vote = (e, data, status, xhr) ->
  votes = $.parseJSON(xhr.responseText)
  $("#answer#{votes.resource_id} .votes").replaceWith(JST["templates/votes"]({votes: votes}))
voteError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $("#answer#{votes.resource_id} .votes-error").append(value)

$(document).on('ajax:success', '.answers .votes', vote)
$(document).on('ajax:error', '.answers .votes', voteError)