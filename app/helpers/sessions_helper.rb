module SessionsHelper
  
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def signed_in_as_admin?
    current_user && current_user.privilege >= 1
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  def require_admin
    unless signed_in_as_admin?
      respond_to do |format|
        format.html {
          flash[:error] = "You must be administrator to do that. "
          redirect_to root_url
        }
        format.json {
          render json: {
            result: 'failure',
            error: 'You must be administrator to do that. '
          }
        }
      end
    end
  end
  
  def require_signed_in
    unless signed_in?
      respond_to do |format|
        format.html {
          flash[:error] = "You must first sign in. "
          redirect_to root_url
        }
        format.json {
          render json: {
            result: 'failure',
            error: 'You must first sign in. '
          }
        }
      end
    end
  end
  
end
