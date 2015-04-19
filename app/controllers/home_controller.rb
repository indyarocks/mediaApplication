class HomeController < ApplicationController
  def index
    if signed_in?
      redirect_to user_path(current_user)
    else
      params[:q] ||= '%'
      @public_media = Media.public_media(params[:q]).paginate(:page => params[:page], :per_page => 30)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
