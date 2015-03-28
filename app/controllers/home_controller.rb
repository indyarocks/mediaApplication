class HomeController < ApplicationController
  def index
    if signed_in?
      redirect_to user_path(current_user)
    else
      @public_media = Media.where(permission: :is_public).paginate(:page => params[:page], :per_page => 30).order("id DESC")
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
