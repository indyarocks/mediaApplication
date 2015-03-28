class Media < ActiveRecord::Base
  belongs_to :user
  PERMISSION =  {is_private: 0, is_public: 1}.freeze
  validates :description, presence: true, length: { maximum: 255}

  VALID_URL_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix

  validates :url, presence: true, format: { with: VALID_URL_REGEX }

end
