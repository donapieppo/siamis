class ConferenceSession < ApplicationRecord
  has_many :organizers, dependent: :destroy
  has_many :chairs, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one  :schedule, dependent: :destroy

  def to_s
    self.name
  end

  def duration 
    Rails.configuration.durations[self.class.to_s.to_sym]
  end

  def is_a_minisymposium?
    self.class == Minisymposium
  end

  # only Minisymposium
  def accept!
    self.update_attribute(:accepted, true)
  end

  # only Minisymposium
  def refuse!
    self.update_attribute(:accepted, false)
  end

  def accepted?
    self.accepted and self.accepted == true
  end

  private

  def create_the_presentation
    self.create_presentation(name: self.name)
  end

end

