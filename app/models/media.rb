class Media < ActiveRecord::Base
  belongs_to :user
  PERMISSION =  {is_private: 0, is_public: 1}.freeze
  validates :description, presence: true, length: { maximum: 255}
  validates :url, presence: true, length: { maximum: 100}
end
