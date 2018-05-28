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

  scope :plenary_or_panel, -> { where("conference_sessions.type IN ('Plenary', 'PanelSession')") }

  scope :accepted,  -> { where(accepted: true) }
  scope :submitted, -> { where(accepted: nil) }

  # Remeber: self.code in Minisymposium, Plenary, Minitutorial, ContributedSession

  def code_with_part(p)
    (self.parts && self.parts > 1) ? "#{self.code}-#{p}" : self.code
  end

  def to_s
    (self.number ? "#{self.code} - " : '') + " " + self.name + ((self.parts && self.parts > 1) ? " (#{self.parts} parts)" : "")
  end

  def to_s_with_part(p)
    (self.number ? code_with_part(p) : '') + " " + self.name 
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

  def author_label
    "Author"
  end

  def schedules_to_s
    self.schedules.map{|s| s.to_s}.join(', ')
  end

  def speakers(part = nil)
    # inefficient ???
    self.presentations.order(:number).where(part: part || 1).map{|p| p.speaker}
    # Author.includes(:user).where(speak: true).where(presentation: self.presentations.order(:number).where(part: part || 1).ids)
  end

  def mono_session?
    false
  end

  # { 1 => [ .., ..], 2 => [.....] }
  def presentations_in_parts
    self.presentations.includes(authors: :user).order(:part, :number, :name).inject({}) do |res, presentation| 
      res[presentation.part] ||= []
      res[presentation.part] << presentation
      res
    end
  end
end

