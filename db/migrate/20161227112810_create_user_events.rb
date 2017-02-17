class CreateUserEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :user_events do |t|
      t.string :name
      t.integer :user_id
      t.datetime :start_date

      t.timestamps
    end
  end
end
