# MonoConferenceSession     < ConferenceSession
# MultipleConferenceSession < ConferenceSession
class ConferenceSession < ApplicationRecord
  has_many :organizers, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :interests, dependent: :destroy

  # useful also for MonoConferenceSession which has one presentation only
  has_many :presentations
  has_many :schedules, dependent: :destroy, foreign_key: :conference_session_id

  include Taggable

  scope :accepted, -> { where(accepted: true) }

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
    self.presentations.each {|p| p.accept!}
  end

  # only Minisymposium
  def refuse!
    self.update_attribute(:accepted, false)
    self.presentations.each {|p| p.refuse!}
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

end

