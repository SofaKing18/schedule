class AddEndDateToUserEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :end_date, :date
    add_column :user_events, :repeat_type, :integer
  end
end
