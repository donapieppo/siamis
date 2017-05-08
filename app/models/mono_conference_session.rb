# ConferenceSession has many presentations.
# Minitutorial and Plenary only one
#
# It could be eitherway: or minitutorial has a name (and description)
# or the presentation has a name. 
# Since you create the minitutorial first we stay with 
# minitutorial with a name. So:
#
# Minitutorial: name
#               description
# Presentation: authors (speaker)
#
class MonoConferenceSession < ConferenceSession 
  has_one :presentation, foreign_key: :conference_session_id, dependent: :destroy

  after_create :create_the_presentation
  
  def authors
    self.presentation and self.presentation.authors
  end

  # assume the first :-)
  def speaker
    self.authors.first
  end

  def accepted?
    true
  end

end

