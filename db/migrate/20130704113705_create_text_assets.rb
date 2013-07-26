class CreateTextAssets < ActiveRecord::Migration
  def self.up
    create_table :text_assets do |t|
      t.string   :document_file_name
      t.string   :document_content_type
      t.integer  :document_file_size

      t.timestamps
    end

  end

  def self.down
#    drop_table :text_assets
  end
end
