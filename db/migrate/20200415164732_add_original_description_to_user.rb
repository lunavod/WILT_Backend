class AddOriginalDescriptionToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :original_description, :text
  end
end
