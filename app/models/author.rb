class Author < Role
  belongs_to :presentation

  scope :speaker, -> { where(speak: true) }

  def only_speaker!
    self.presentation.authors.each do |a|
      a.update_attribute(:speak, a == self)
    end
  end

end
