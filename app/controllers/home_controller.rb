class HomeController < ApplicationController
  def index
    if signed_in?
      redirect_to user_path(current_user)
    else
      params[:q] ||= '%'
      @public_media = Media.where("description LIKE ? AND permission = ?", "#{params[:q]}%", Media::PERMISSION[:is_public]).paginate(:page => params[:page], :per_page => 30).order("id DESC")
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
