# see Minitutorial notes
class Plenary < ConferenceSession
  has_one :presentation, foreign_key: :conference_session_id, dependent: :destroy

  after_create :create_the_presentation

  def authors
    self.presentation.authors
  end

  # assume the first :-)
  def speaker
    self.authors.first
  end

  def code
    "IP#{self.number || ""}" 
  end

  def accepted?
    true
  end

  alias chairs organizers
end
