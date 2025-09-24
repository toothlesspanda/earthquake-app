class Earthquake < ApplicationRecord
  has_one_attached :image_for_3d
  has_one_attached :heightmap_image

  def self.ransackable_attributes(auth_object = nil)
    %w[coordinates created_at depth_km event_id id magnitude metadata occurred_at title tsunami updated_at]
  end
end
