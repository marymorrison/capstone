class CreatePeeps < ActiveRecord::Migration[5.0]
  def change
    create_table :peeps do |t|
      t.string :name
      t.boolean :followee
      t.boolean :follower
      t.string :uid

      t.timestamps
    end
  end
end
