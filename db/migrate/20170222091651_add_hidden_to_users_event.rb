class AddHiddenToUsersEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :hidden, :boolean, default: false
  end
end
