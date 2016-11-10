class Organizer < Role
  belongs_to :minisymposium, foreign_key: :conference_session_id, optional: true
  belongs_to :minitutorial,  foreign_key: :conference_session_id, optional: true
  belongs_to :conference_session, foreign_key: :conference_session_id, optional: true

end
