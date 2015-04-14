var ready;
ready = function() {
  // show form for question
  $('.edit-question-link').click(function(){
    $(this).hide();
    $('.question-edit-form').show();
  });

  // show form for answer
  $('.edit-answer-link').click(function() {
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('#answer' + answer_id).find('.answer-edit-form').show();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);