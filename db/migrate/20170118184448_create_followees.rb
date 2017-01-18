class CreateFollowees < ActiveRecord::Migration[5.0]
  def change
    create_table :followees do |t|
      t.references :user, foreign_key: true
      t.references :peep, foreign_key: true

      t.timestamps
    end
  end
end
