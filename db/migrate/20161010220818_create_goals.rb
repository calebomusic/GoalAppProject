class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :description, null: false
      t.integer :user_id, null: false
      t.boolean :status, null: false
      t.boolean :private, null: false
      t.timestamps null: false
    end
  end
end
