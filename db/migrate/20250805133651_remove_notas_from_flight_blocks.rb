class RemoveNotasFromFlightBlocks < ActiveRecord::Migration[8.0]
  def change
    remove_column :flight_blocks, :notas, :text
  end
end
