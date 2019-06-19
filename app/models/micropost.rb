class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :event_date, presence: true
  validate  :event_date_cannot_be_in_the_past
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    # event_dateに過去日は設定不可
    def event_date_cannot_be_in_the_past
      if event_date.nil? || event_date.past?
        errors.add(:event_date, "can not specify past date")
      end
    end
end
