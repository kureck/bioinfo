class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.string :title
      t.text :description
      t.string :csvfile
      t.integer :initial_data_id

      t.timestamps
    end
  end
end
