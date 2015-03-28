class UsersController < ApplicationController

  before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :is_signed_in, only: [:new, :create]

  def show
    @user = User.find(params[:id])
    @new_media = current_user.medias.build
    params[:q] ||= '%'
    @medias = @user.medias.where('description LIKE ?', "#{params[:q]}%").paginate(:page => params[:page], :per_page => 30)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Media Community!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end


  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
    # Before filters

    def correct_user
      @user = User.find(params[:id]) # rescue nil, just in case there is no user with params[:id]
      redirect_to(root_url) unless current_user?(@user)
    end

    def is_signed_in
      redirect_to(root_url) if signed_in?
    end
end
