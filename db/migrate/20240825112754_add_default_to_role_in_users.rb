class AddDefaultToRoleInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :role, from: nil, to: 1
  end
end
