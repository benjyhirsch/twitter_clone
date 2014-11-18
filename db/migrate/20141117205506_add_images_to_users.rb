class AddImagesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_url, :string
    add_column :users, :header_image_url, :string
  end
end
