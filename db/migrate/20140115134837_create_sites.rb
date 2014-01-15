class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :url
      t.string :urn
      t.integer :user_id
      t.float :crawl_time

      t.timestamps
    end
  end
end
