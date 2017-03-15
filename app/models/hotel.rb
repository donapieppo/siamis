class Hotel < ApplicationRecord

  def to_s
    self.name
  end

  def asset_image
   'hotels/' + ['hotel-savoia.jpg', 'savoia-hotel-country.jpg', 'campluscollege.jpg'][self.id - 1] 
  end

end

