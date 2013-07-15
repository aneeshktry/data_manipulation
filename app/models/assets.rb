class Assets < ActiveRecord::Base
  set_table_name "assets"

  attr_accessible :document

  has_attached_file :document ,
    :url => "/tmp/txt_files/:id/:basename.:extension",
    :path => ":rails_root/tmp/txt_files/:id/:basename.:extension"

  validates_attachment_presence :document
  validates_format_of :document_file_name, :with => %r{\.(|txt|)$}i
  validates_attachment_size :document, :less_than => 10.megabytes, :greater_than => 2.kilobytes, :message => "File size must be between 2KB and 5MB"
  validates_attachment_content_type :document, :content_type => ['application/txt', 'text/plain']


end
