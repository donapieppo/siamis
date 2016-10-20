class Author < ApplicationRecord
  include Role

  belongs_to :user
  belongs_to :presentation

  before_validation :set_or_create_user_from_email

  def to_s
    self.user.to_s
  end
end
