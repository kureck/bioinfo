class CreateInitialData < ActiveRecord::Migration
  def change
    create_table :initial_data do |t|
      t.integer :user_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
