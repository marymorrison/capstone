class UnChangeColumnUidDataTypesFromPeepsAndUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :peeps, :uid,  :string
    change_column :users, :uid,  :string
  end
end
