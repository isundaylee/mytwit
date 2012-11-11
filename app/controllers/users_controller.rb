class UsersController < ApplicationController
  
  before_filter :require_admin, only: [:index, :destroy]
  before_filter :require_signed_in, only: [:edit, :update, :edit_avatar, :update_avatar, :follow, :unfollow]
  around_filter :rescue_user_not_found, only: [:destroy, :edit, :update, :show, :edit_avatar, :update_avatar, :follow, :unfollow]
  
  USER_SEARCH_RESULTS_PER_PAGE = 5
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User successfully deleted. "
    redirect_to users_url
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save then
      sign_in @user
      flash[:success] = "Your account is successfully created. "
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    require_admin unless @user == current_user
  end
  
  def update
    @user = User.find(params[:id])
    require_admin unless @user == current_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile successfully updated. "
      sign_in @user
      redirect_to root_url
    else
      render 'edit'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit_avatar
    @user = User.find(params[:id])
    require_admin unless @user == current_user
  end
  
  def update_avatar
    @user = User.find(params[:id])
    require_admin unless @user == current_user
    @user.avatar = params[:user][:avatar]
    if @user.save validate: false
      flash[:success] = 'You have successfully changed your avatar! '
      sign_in @user
    else
      flash[:error] = @user.errors.full_messages.join('<br />').html_safe
    end

    redirect_to edit_avatar_user_url(@user)
  end
  
  def follow
    @user = User.find(params[:id])
    @cu = current_user
    existing = @cu.followees.where({id: @user.id}).first
    if @user == @cu
      flash[:warning] = 'You cannot follow yourself. '
    elsif existing
      flash[:warning] = 'You have already followed this user. '
    else
      @cu.followees << @user
      @cu.save validate: false
      sign_in @cu
      flash[:success] = 'You have successfully followed this user. '
    end
    redirect_to show_timeline_url(@user)
  end
  
  def unfollow
    @user = User.find(params[:id])
    @cu = current_user
    existing = @cu.followees.where({id: @user.id}).first
    if existing
      @cu.followees.delete @user
      @cu.save validate: false
      sign_in @cu
      flash[:success] = 'You have successfully unfollowed this user. '
    else
      flash[:warning] = "You haven't followed this user yet. "
    end
    redirect_to show_timeline_url(@user)
  end
  
  def search
    @query = params[:search][:query]
    if @query.empty?
      @users = []
    else
      @users = User.where("email like ? OR name like ?", '%' + @query + '%', '%' + @query + '%').order('created_at DESC').paginate(page: params[:page], per_page: USER_SEARCH_RESULTS_PER_PAGE)
    end
  end
  
  private
  
    def rescue_user_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Invalid user. "
      redirect_to root_url
    end
  
end
