class AccountActivationsController < ApplicationController
  before_action :find_user, only: %i(edit)

  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t(".success")
      redirect_to @user
    else
      flash[:danger] = t(".danger")
      redirect_to root_url
    end
  end

  private

  def find_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t(".not_found")
    redirect_to root_url
  end
end
