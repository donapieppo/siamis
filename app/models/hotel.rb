class Hotel < ApplicationRecord

  def to_s
    self.name
  end

  def asset_image
    return "" if self.image.blank?
   'hotels/' + self.image 
  end

  def self.geocodes
    self.all.map {|hotel| [hotel.lat, hotel.lng, hotel.name, hotel.address, hotel.id]}
  end

end

