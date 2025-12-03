class AddColumnToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :age, :integer
    add_column :users, :weight, :float
    add_column :users, :height, :integer
    add_column :users, :level_running, :string
  end
end
