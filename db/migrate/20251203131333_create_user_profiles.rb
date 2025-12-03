class CreateUserProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_profiles do |t|
      t.integer :weight
      t.integer :height
      t.integer :age
      t.string :level
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
