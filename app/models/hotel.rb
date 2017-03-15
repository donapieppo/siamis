class Hotel < ApplicationRecord

  def to_s
    self.name
  end

  def image
   'hotels/' + ['hotel-savoia.jpg', 'savoia-hotel-country.jpg', 'campluscollege.jpg'][self.id - 1] 
  end

end

