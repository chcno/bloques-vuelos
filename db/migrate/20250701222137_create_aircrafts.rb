class CreateAircrafts < ActiveRecord::Migration[8.0]
  def change
    create_table :aircrafts do |t|
      t.string :model
      t.string :identifier
      t.string :status

      t.timestamps
    end
  end
end
