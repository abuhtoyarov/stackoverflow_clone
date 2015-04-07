$(editQuestionLink);
$(editAnswerLink);

function editQuestionLink(jQuery){
  $('.edit-question-link').click(function(e){
    $(this).hide();
    $('.question-edit-form').show();
  });
};

function editAnswerLink(jQuery){
  $('.edit-answer-link').click(function() {
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('#answer' + answer_id).find('.answer-edit-form').show();
  })
}