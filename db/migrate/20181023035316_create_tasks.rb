class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :user_id, index: true, null: false
      t.integer :position
      t.boolean :completed, default: false
      t.datetime :due
      t.text :description, null: false

      t.timestamps
    end
  end
end
