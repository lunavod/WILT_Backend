class AddUserRefToPost < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :creator, references: :users, index: true
  end
end
