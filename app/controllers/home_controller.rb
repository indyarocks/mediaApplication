class HomeController < ApplicationController
  def index
    @public_media = Media.where(permission: :is_public).paginate(:page => params[:page], :per_page => 30).order("id DESC")
  end

  def help
  end

  def about
  end

  def contact
  end
end
