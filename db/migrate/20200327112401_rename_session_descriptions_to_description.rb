class RenameSessionDescriptionsToDescription < ActiveRecord::Migration[6.0]
  def change
    rename_column :sessions, :descriptions, :description
  end
end
