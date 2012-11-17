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
  
  def has_followed(user)
    nil unless signed_in?
    @cu = current_user
    current_user.followees.where({id: user.id}).first
  end
  
end
