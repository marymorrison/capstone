class RemoveFollowersAndFollowingColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :followers, :string
    remove_column :users, :following, :string
    remove_column :users, :email, :string
  end
end
