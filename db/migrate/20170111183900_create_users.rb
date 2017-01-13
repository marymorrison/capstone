class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :oauth_token
      t.string :oauth_secret
      t.string :email
      t.string :followers
      t.string :following

      t.timestamps
    end
  end
end
