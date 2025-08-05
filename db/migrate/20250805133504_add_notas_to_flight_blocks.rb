class AddNotasToFlightBlocks < ActiveRecord::Migration[8.0]
  def change
    add_column :flight_blocks, :notas, :text
  end
end
