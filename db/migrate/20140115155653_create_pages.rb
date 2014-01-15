class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :site_id
      t.boolean :passed
      t.string :error_message
      t.boolean :basic_test
      t.boolean :head_banner
      t.boolean :head_mediabar
      t.boolean :body_banner
      t.boolean :body_mediabar

      t.timestamps
    end
  end
end
