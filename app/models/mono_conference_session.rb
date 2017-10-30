# ConferenceSession has many presentations.
# Minitutorial and Plenary only one
#
# It could be eitherway: or minitutorial has a name (and description)
# or the presentation has a name. 
# Since you create the minitutorial first we stay with 
# minitutorial with a name. So:
#
# Minitutorial < MonoConferenceSession
# Plenary      < MonoConferenceSession
class MonoConferenceSession < ConferenceSession 
  has_one :presentation, foreign_key: :conference_session_id, dependent: :destroy

  after_create :create_the_presentation
  after_update :update_presentation_name
  
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

  def schedule
    self.schedules.first
  end

  private

  def create_the_presentation
    self.create_presentation(name: self.name)
  end

  def update_presentation_name
    self.presentation.update_attribute(:name, self.name)
  end

end

