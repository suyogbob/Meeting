class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.references :user
      t.references :friend
      t.references :location
      t.string :agenda
      t.datetime :start_time
      t.datetime :end_time
      t.string :state

      t.timestamps
    end
  end
end
