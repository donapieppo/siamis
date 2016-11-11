# In general many presnetations
# In Siam is18 only one so we getr data from it
class Plenary < ConferenceSession
  after_create :add_relative_presentation

  def presentation
    @presentation ||= presentations.first
  end

  def speaker
    self.presentation.authors.first
  end

  private

  def add_relative_presentation
    @presentation = self.presentations.create(name: self.name)
  end
end
