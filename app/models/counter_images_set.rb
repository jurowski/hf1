class CounterImagesSet < ActiveRecord::Base
  has_many :levels
  has_many :counter_images
end
