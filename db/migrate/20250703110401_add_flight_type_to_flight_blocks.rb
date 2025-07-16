class AddFlightTypeToFlightBlocks < ActiveRecord::Migration[8.0]
  def change
    # migration:
add_column :flight_blocks, :flight_type, :string

  end
end
