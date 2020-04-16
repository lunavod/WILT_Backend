class AddOriginalTextToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :original_text, :string
  end
end
