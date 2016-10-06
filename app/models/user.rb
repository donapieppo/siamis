class User < ApplicationRecord
  has_many :admins

  def to_s
    self.name
  end

  def owns!(what)
    self.owns?(what) or raise NoAccess
  end

  def owns?(what)
    self.master_of_universe? and return true
    false
  end

  def master_of_universe?
    MASTERS_OF_UNIVERSE.include?(self.email)
  end
end

