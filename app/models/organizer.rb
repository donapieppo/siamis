class Organizer < ApplicationRecord
  include Role

  belongs_to :user
  belongs_to :minisymposium, foreign_key: :session_id, optional: true
  belongs_to :minitutorial,  foreign_key: :session_id, optional: true

  before_validation :set_or_create_user_from_email

  def to_s
    self.user.to_s
  end

end
