class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|

      t.string   :document_file_name
      t.string   :document_content_type
      t.integer  :document_file_size

      t.timestamps
    end

  end

  def self.down
    drop_table :assets
  end
end
