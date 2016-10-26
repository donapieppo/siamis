class Building < ApplicationRecord
  has_many :rooms

  def to_s
    self.name
  end

end

