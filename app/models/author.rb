class Author < Role
  belongs_to :presentation

  def is_speaker!
    self.presentation.authors.each do |a|
      a.update_attribute(:speak, a == self)
    end
  end

  def photo_asset
    unless self.user.email.blank?
      image_base_name = self.user.email.gsub(/@.*/, '').gsub(/[^0-9A-Za-z.\-]/, '_')
      "speakers/#{image_base_name}.jpg"
    end
  end
end
