class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :minisymposium, foreign_key: :conference_session_id, optional: true
  belongs_to :minitutorial,  foreign_key: :conference_session_id, optional: true
  belongs_to :presentation,  optional: true

  def to_s
    "#{self.user}: #{self.score}"
  end

  def about
    self.minitutorial || self.minisymposium || self.presentation
  end

  def about_string
    case what = about
    when Minitutorial, Minisymposium
      "#{what} (#{what.organizers.map(&:user).join(', ')})"
    when Presentation
      "#{what} (#{what.authors.map(&:to_s).join(', ')})"
    else
      ""
    end
  end

end

