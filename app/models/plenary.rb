# see Minitutorial notes
class Plenary < ConferenceSession
  DURATION = 45

  has_one :presentation, foreign_key: :conference_session_id, dependent: :destroy

  after_create :create_the_presentation

  def speakers
    self.presentation.authors.map(&:to_s).join(', ')
  end
end
