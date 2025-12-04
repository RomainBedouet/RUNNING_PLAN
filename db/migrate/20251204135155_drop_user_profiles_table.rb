class DropUserProfilesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :user_profiles
  end
end
