class Hotel < ApplicationRecord

  def to_s
    self.name
  end

  def asset_image
    return "" if self.image.blank?
   'hotels/' + self.image 
  end

  def self.google_map_array
    self.all.map {|hotel| { id: hotel.id,
                            position: {lat: hotel.lat, lng: hotel.lng}, 
                            name: hotel.name, 
                            address: hotel.address }}
  end

end

