class AddStudent2AndSafetyToFlightBlocks < ActiveRecord::Migration[8.0]
  def change
    add_column :flight_blocks, :safety_id, :integer
add_column :flight_blocks, :student2_id, :integer

  end
end
