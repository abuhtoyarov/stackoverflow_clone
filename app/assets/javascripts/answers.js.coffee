# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append(JST["templates/answers/answer"]({answer: answer}))


# $ ->
#   $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
#     answer = $.parseJSON(xhr.responseText)
#     $('.answers').append(answer.body)
#   .bind 'ajax:error', (e, xhr, status, error) ->
#     errors = $.parseJSON(xhr.responseText)
#     $.each errors, (index, value) ->
#       $('.answers-error').append(value)