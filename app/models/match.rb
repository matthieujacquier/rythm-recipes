class Match < ApplicationRecord
  belongs_to :user
  belongs_to :music_suggestion
  has_one :recipe
end
