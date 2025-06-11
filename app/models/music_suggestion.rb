class MusicSuggestion < ApplicationRecord
  has_many :matches

  validates :artists, presence: true
  validates :genre, presence: true
  validates :image_url, presence: true
end
