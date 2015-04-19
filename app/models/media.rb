class Media < ActiveRecord::Base
  validates :user_id, presence: true
  belongs_to :user
  PERMISSION_HASH =  {is_private: 0, is_public: 1}.freeze
  validates :permission, :inclusion => {:in =>[PERMISSION_HASH[:is_private], PERMISSION_HASH[:is_public]]}
  validates :description, presence: true, length: { maximum: 255}

  VALID_URL_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix

  validates :url, presence: true,
            format: { with: VALID_URL_REGEX, message: "Invalid url. A valid url format is: http(s)://www.example.com" }

  # Fetches public media
  def self.public_media(keyword='')
    where("LOWER(description) LIKE LOWER(?) AND permission = ?", "%#{keyword}%", Media::PERMISSION_HASH[:is_public]).order("id DESC")
  end


end
