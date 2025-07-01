class AddFieldsToUsersRoleAndMor < ActiveRecord::Migration[8.0]
  def change
      change_column_default :users, :role, 0
    change_column_null :users, :role, false
  end
end
