module UsersHelper
  
  def avatar_for(user, options = {})
    return image_tag(user.avatar_path, options);
  end
  
  def description_for(user)
    if user.description && !user.description.empty?
      user.description
    else
      'No description. '
    end
  end
  
  def has_followed?(user)
    false unless signed_in?
    current_user.has_followed?(user)
  end

  def has_mutual_relationship_with?(b)
    false unless signed_in?
    current_user.has_mutal_relationship_with?(b)
  end
  
end
