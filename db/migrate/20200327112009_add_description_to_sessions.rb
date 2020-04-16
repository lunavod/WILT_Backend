class AddDescriptionToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :descriptions, :string
  end
end
