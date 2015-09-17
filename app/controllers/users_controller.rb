class UsersController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_user!
    else
      flash.now["errors"] = @user.errors.full_messages
      render :new
    end
  end

  def update
    @user = User.find_by_credentials(params[:username], params[:password])
    if @user.update(user_params)
      flash.now["notice"] = "#{@user.name} has been updated!"
      redirect_to user_url(@user)
    else
      flash.now["errors"] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user = User.find_by_credentials(params[:username], params[:password])
    @user.destroy
    redirect_to users_url
  end

  def edit
    render :edit
  end

  private

  def user_params
      params.require(:user).permit(:username, :password)
  end
end
