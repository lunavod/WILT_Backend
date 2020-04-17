class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
    add_reference :invites, :creator, references: :users, index: true
    add_reference :invites, :user, references: :users, index: true
  end
end
