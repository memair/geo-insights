class Place < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id, message: "Each place should have a unique name" }
  validates :latitude, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
