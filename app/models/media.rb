class Media < ActiveRecord::Base
  belongs_to :user
  enum permission: [:is_private, :is_public]
  validates :description, presence: true, length: { maximum: 255}
  validates :url, presence: true, length: { maximum: 100}
end
