class AddColumnImageUrlToPeep < ActiveRecord::Migration[5.0]
  def change
    add_column :peeps, :image_url, :string
  end
end
