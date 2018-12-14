class Place < ApplicationRecord
  belongs_to :user

  auto_strip_attributes :name, squish: true

  validates :name, presence: true, uniqueness: { scope: :user_id, message: "Each place should have a unique name", case_sensitive: false }
  validates :latitude, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
