class Review < ApplicationRecord
  belongs_to :location

  validates :text, presence: true
end
