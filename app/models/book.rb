class Book < ApplicationRecord
  is_impressionable
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == "perfect"
      Book.where(title: content)
    elsif method == "forward"
      Book.where("title LIKE ?", content+"%")
    elsif method == "backward"
      Book.where("title LIKE ?", "%"+content)
    else
      Book.where("title LIKE ?", "%"+content+"%")
    end
  end
end
