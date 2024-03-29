class UsersController < ApplicationController
  before_action :admin_user, only: %i(destroy)
  before_action :find_user, only: %i(show update edit destroy following)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)

  def edit; end

  def show
    @pagy, @microposts = pagy @user.microposts
  end

  def index
    @pagy, @users = pagy User.asc_name_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t(".info")
      redirect_to login_url
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t(".success")
      redirect_to @user
    else
      flash.now[:danger] = t(".danger")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".danger")
    end
    redirect_to users_path
  end

  def following
    @title = t ".following"
    @pagy, @users = pagy @user.following
    render :show_follow
  end

  def followers
    @title = t ".followers"
    @pagy, @users = pagy @user.followers
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if @user

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
