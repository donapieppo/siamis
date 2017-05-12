class Building < ApplicationRecord
  has_many :rooms

  def to_s
    self.name
  end

  def self.google_map_array
    self.all.map {|building| { id: building.id,
                               position: {lat: building.lat, lng: building.lng}, 
                               name: building.name, 
                               address: building.address }}
  end

end

