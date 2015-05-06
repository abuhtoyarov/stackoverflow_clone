json.can_vote current_user.can_vote?(@resource)
json.resource_path url_for(@resource)
json.score @resource.score
json.resource_id @resource.id