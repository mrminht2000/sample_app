class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.microposts.length.max}
  validates :image, content_type: {in: Settings.image.type,
                                   message: :invalid_format},
                    size: {less_than: Settings.image.max_size.megabytes,
                           message: :large_size}

  default_scope ->{order(created_at: :desc)}

  def display_image
    image.variant resize_to_limit: [Settings.image.resize_x,
                                    Settings.image.resize_y]
  end
end
