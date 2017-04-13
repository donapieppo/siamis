class Author < Role
  belongs_to :presentation

  def speaker!
    self.presentation.authors.each do |a|
      a.update_attribute(:speak, a == self)
    end
  end

end
