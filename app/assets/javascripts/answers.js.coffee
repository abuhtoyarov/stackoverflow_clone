# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('form.new_answer,form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    content = JST["templates/answers/answer"]({answer: answer})
    if ($(this).is('form.new_answer'))
      $('.answers').append(content)
    else
      $("#answer#{answer.id}").replaceWith(content)
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answers-error').append(value)

vote = (e, data, status, xhr) ->
  votes = $.parseJSON(xhr.responseText)
  $("#answer#{votes.resource_id} .votes").replaceWith(JST["templates/votes"]({votes: votes}))
voteError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $("#answer#{votes.resource_id} .votes-error").append(value)

$(document).on('ajax:success', '.answers .votes', vote)
$(document).on('ajax:error', '.answers .votes', voteError)