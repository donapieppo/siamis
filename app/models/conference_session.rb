class ConferenceSession < ApplicationRecord
  has_many :organizers, dependent: :destroy
  has_many :chairs
  has_many :ratings, dependent: :destroy
  has_one  :schedule

  def to_s
    self.name
  end

  def duration 
    DURATION
  end

  def is_a_minisymposium?
    self.class == Minisymposium
  end

  private

  def create_the_presentation
    self.create_presentation(name: self.name)
    # @presentation = self.presentations.first || self.presentations.new
    # @presentation.name = self.name
    # @presentation.save
  end
end



