class Building < ApplicationRecord
  has_many :rooms

  MAP_DIR    = 'maps' # in /public

  MAP_IMAGES = [ 'f01-Belmeloro14_p0.png',
                 'f02-Belmeloro14_p1.png',
                 'f03-Belmeloro14_p2.png',
                 'f04-Belmeloro14_p3.png',
                 'f06-Belmeloro10-12_p1.png',
                 'f05-Belmeloro10-12_p0.png' ]

  def to_s
    self.name
  end

  def self.google_map_array
    self.order(:id).all.map {|building| { id: building.id,
                                    position: {lat: building.lat, lng: building.lng}, 
                                        name: building.name, 
                                 description: building.description, 
                                     address: building.address }}
  end

  # |  1 | Palazzina A - Building A |
  # |  3 | Palazzina B - Building B |
  # |  4 | SP.I.S.A.                |
  # |  5 | Redenti                  |  
  # |  6 | Matemates                |  
  #
  # 2 santa lucia
  def image(floor_num=0)
    file_name = case id 
    when 1, 3, 6 #  Palazzina A - Building A -  Palazzina B - Building B - Matemates
      ['f01-Belmeloro14_p0.png', 'f02-Belmeloro14_p1.png', 'f03-Belmeloro14_p2.png', 'f04-Belmeloro14_p3.png'][floor_num]
    when 4, 5
      ['f05-Belmeloro10-12_p0.png', 'f06-Belmeloro10-12_p1.png'][floor_num]
    when 2
      'aula_magna_santa_lucia.png'
    else
      nil
    end
    file_name ? (MAP_DIR + '/' + file_name) : ''
  end

  def satelite_image
    MAP_DIR + '/' + case id
    when 1
      'satellite_a.png'
    when 2
      'satellite_santa_lucia.png'
    when 3
      'satellite_b.png'
    when 4
      'satellite_spisa.png'
    when 5
      'satellite_redenti.png'
    when 6
      'satellite_matemates.png'
    else
      ''
    end
  end
end

