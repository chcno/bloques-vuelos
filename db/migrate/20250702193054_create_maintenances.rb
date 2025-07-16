class CreateMaintenances < ActiveRecord::Migration[8.0]
  def change
    create_table :maintenances do |t|
      t.references :aircraft, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.string :reason

      t.timestamps
    end
  end
end
