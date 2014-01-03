class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :url
      t.string :keyword
      t.string :status

      t.timestamps
    end
  end
end
