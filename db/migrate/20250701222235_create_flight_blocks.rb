class CreateFlightBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :flight_blocks do |t|
      t.references :aircraft, null: false, foreign_key: true
      t.integer :instructor_id
      t.integer :student_id
      t.datetime :start_time 
      t.datetime :end_time
      t.text :notes

      t.timestamps
    end
  end
end
