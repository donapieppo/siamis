class Paper < ApplicationRecord
  include PaperfileUploader::Attachment.new(:paperfile)
  
  belongs_to :presentation
end

