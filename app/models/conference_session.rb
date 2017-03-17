class ConferenceSession < ApplicationRecord
  has_many :organizers, dependent: :destroy
  has_many :roles
  has_many :ratings, dependent: :destroy
  has_many :interests, dependent: :destroy
  has_one  :schedule, dependent: :destroy

  def to_s
    self.name
  end

  # Minisymposium, Plenary, Contributed Session
  def class_name
    I18n.t(self.class.to_s)
  end

  def duration 
    Rails.configuration.durations[self.class.to_s.to_sym]
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

  def ratable?
    false
  end

  # Chair (singular) for all except minisymposia where are organizers (plural)
  def organizers_label
    "Chair"
  end

  private

  def create_the_presentation
    self.create_presentation(name: self.name)
  end

end

