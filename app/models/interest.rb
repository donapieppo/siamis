class Interest < ApplicationRecord
  belongs_to :user
  has_many :conference_sessions
  has_many :presentations

end

