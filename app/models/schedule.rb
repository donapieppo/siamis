class Schedule < ApplicationRecord
  belongs_to :session
  belongs_to :room
end
