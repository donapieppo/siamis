class Session < ApplicationRecord
  has_many :organizers, dependent: :destroy
  has_many :presentations # FIXME dependent
  has_many :ratings, dependent: :destroy

  validates :name, uniqueness: true

  def to_s
    self.name
  end

end



