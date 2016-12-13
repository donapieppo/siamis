# ConferenceSession has many presentations.
# Minitutorial ans Plenary only one
#
# It could be eitherway: or minitutorial has a name (and description)
# or the presentation has a name. 
# Since you create the minitutorial first we stay with 
# minitutorial with a name. So:
#
# Minitutorial: name
#               description
#               chairs
# Presentation: authors (speaker)
#
class Minitutorial < ConferenceSession
  DURATION = 120

  has_one :presentation, foreign_key: :conference_session_id, dependent: :destroy

  after_create :create_the_presentation

  def speakers
    self.presentation.authors_to_s
  end
end


