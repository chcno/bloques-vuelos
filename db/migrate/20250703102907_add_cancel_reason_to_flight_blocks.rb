class AddCancelReasonToFlightBlocks < ActiveRecord::Migration[8.0]
  def change
    add_column :flight_blocks, :cancel_reason, :string
  end
end
