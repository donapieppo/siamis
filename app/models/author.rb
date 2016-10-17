class Author <  Role
  belongs_to :user
  belongs_to :presentation

  def to_s
    self.user.to_s
  end
end
