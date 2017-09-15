module Taggable
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :tags, join_table: :taggins
  end
  
  # return a string 
  def manual_tags
    tags.not_global.map(&:name).join(", ")
  end

  def manual_tags=(s)
    # raise Tag.add_manual_tags(s).inspect
    tags << Tag.add_manual_tags(s)
  end
end

