$(editQuestionLink);

function editQuestionLink(jQuery){
  $('.edit-question-link').click(function(e){
    $(this).hide();
    $('.question-edit-form').show();
  });
};