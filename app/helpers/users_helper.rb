module UsersHelper
  
  def avatar_for(user, options = {})
    return image_tag(user.avatar_path, options);
  end
  
end
