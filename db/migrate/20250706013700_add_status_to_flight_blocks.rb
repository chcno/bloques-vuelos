class AddStatusToFlightBlocks < ActiveRecord::Migration[8.0]
  def change
    add_column :flight_blocks, :status, :string
  end
end
