json.can_vote? current_user.can_vote?(@question)
json.resource_path url_for(@question)
json.score @question.score