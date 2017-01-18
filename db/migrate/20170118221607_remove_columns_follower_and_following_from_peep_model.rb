class RemoveColumnsFollowerAndFollowingFromPeepModel < ActiveRecord::Migration[5.0]
  def change
    remove_column :peeps, :follower, :string  
    remove_column :peeps, :following, :string
  end
end
