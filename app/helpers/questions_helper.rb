module QuestionsHelper
  def user_is_owner?
    current_user.id == @question.user_id
  end
end
