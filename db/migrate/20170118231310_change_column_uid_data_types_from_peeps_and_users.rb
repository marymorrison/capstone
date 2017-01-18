class ChangeColumnUidDataTypesFromPeepsAndUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :peeps, :uid,  :integer
    change_column :users, :uid,  :integer
  end
end
