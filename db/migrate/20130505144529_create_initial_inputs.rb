class CreateInitialInputs < ActiveRecord::Migration
  def change
    create_table :initial_inputs do |t|
      t.integer :user_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
