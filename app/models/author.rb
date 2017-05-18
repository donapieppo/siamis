class Author < Role
  belongs_to :presentation

  def only_speaker!
    self.presentation.authors.each do |a|
      a.update_attribute(:speak, a == self)
    end
  end

end
