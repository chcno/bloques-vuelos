class AddLastNotifiedAtToFlightBlocks < ActiveRecord::Migration[8.0]
  def change
        add_column :flight_blocks, :last_notified_at, :datetime

  end
end
