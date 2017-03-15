class Hotel < ApplicationRecord

  def to_s
    self.name
  end

  def asset_image
    return "" if self.image.blank?
   'hotels/' + self.image 
  end

end

