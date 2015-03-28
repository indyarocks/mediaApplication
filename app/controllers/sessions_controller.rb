class SessionsController < ApplicationController

  def new
    redirect_to root_path if current_user.present?
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = "Invalid email/password combination."
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  private

    def session_params
      params.permit(:email, :password)
    end
end
