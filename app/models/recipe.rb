class Recipe < ApplicationRecord
  has_many :matches, dependent: :destroy
end
