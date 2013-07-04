class Assets < ActiveRecord::Base
  set_table_name "assets"

  attr_accessible :document
end
