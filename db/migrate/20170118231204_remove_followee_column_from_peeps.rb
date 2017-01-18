class RemoveFolloweeColumnFromPeeps < ActiveRecord::Migration[5.0]
  def change
    remove_column :peeps, :followee, :string
  end
end
