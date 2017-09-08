class Tag < ApplicationRecord
  has_and_belongs_to_many :conference_sessions, join_table: :taggins
  has_and_belongs_to_many :minisymposia,        join_table: :taggins, association_foreign_key: :conference_session_id
  has_and_belongs_to_many :presentations,       join_table: :taggins

  validates_uniqueness_of :name

  def to_s
     name
  end

  def self.all_tags
    Tag.order(:name).select(:name).map(&:name).join(', ')
  end
end
