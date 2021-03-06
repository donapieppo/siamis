class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :minisymposium, foreign_key: :conference_session_id, optional: true
  belongs_to :presentation,  optional: true

  def to_s
    "#{self.user}: #{self.score}"
  end

  def about
    self.minisymposium || self.presentation
  end

  # def about_string
  #   case what = about
  #   when Minitutorial, Minisymposium
  #     "#{what} (#{what.organizers.map(&:user).join(', ')})"
  #   when Presentation
  #     "#{what} (#{what.authors.map(&:to_s).join(', ')})"
  #   else
  #     ""
  #   end
  # end

  def self.excellence
    5
  end

  def self.get_unrated_minisymposium(user)
    Minisymposium.where(accepted: nil).where.not(id: user.ratings.map(&:conference_session_id)).first
  end

  def self.get_unrated_presentation(user)
    Presentation.unassigned.where.not(id: user.ratings.map(&:presentation_id)).first
  end

end

