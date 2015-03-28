class MediasController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :destroy

  def create
    @media = current_user.medias.build(description: media_params[:description],
                                      url: media_params[:url], permission: media_params[:permission].to_i)
    if @media.save
      flash[:success] = "Media created!"
    else
      flash[:error] = @media.errors.full_messages.join(',  ')
    end
    redirect_to root_url

  end

  def destroy
    @media.destroy
    redirect_to root_url
  end


  private
    def media_params
      params.require(:media).permit(:description, :permission, :url)
    end

    def correct_user
      @media = current_user.medias.find_by(id: params[:id])
      redirect_to root_url if @media.nil?
    end
end
