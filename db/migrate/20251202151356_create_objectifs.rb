class CreateObjectifs < ActiveRecord::Migration[7.1]
  def change
    create_table :objectifs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.float :actual_time
      t.float :goal_time
      t.float :km

      t.timestamps
    end
  end
end
