class Tag < ApplicationRecord
  has_and_belongs_to_many :conference_sessions, join_table: :taggins
  has_and_belongs_to_many :minisymposia,        join_table: :taggins, association_foreign_key: :conference_session_id
  has_and_belongs_to_many :presentations,       join_table: :taggins

  validates_uniqueness_of :name

  scope :global,     -> { where(global: true) }
  scope :not_global, -> { where('global = 0 or global IS NULL') }

  def to_s
     name
  end

  def self.all_tags
    Tag.order(:name).select(:name).map(&:name).join(', ')
  end

  # ????? downcase! Downcases the contents of str, returning nil if no changes were made. 
  def self.add_manual_tags(tags_string)
    tags_string.split(',').map do |ts|
      t = ts.downcase.strip
      if existent_tag = Tag.where(name: t).first
        existent_tag
      else
        logger.info("Create tag #{t}")
        Tag.create(name: t)
      end
    end
  end
end
