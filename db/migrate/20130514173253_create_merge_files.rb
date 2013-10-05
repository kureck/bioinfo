class CreateMergeFiles < ActiveRecord::Migration
  def change
    create_table :merge_files do |t|
      t.integer :file1_id
      t.string :file_field_1
      t.string :file2_id
      t.string :file_field_2

      t.timestamps
    end
  end
end
