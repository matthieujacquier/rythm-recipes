class Recipe < ApplicationRecord
  belongs_to :match, optional: true
end
