class AddNotificationJobIdToFlightBlocks < ActiveRecord::Migration[8.0]
  def change
    add_column :flight_blocks, :notification_job_id, :string
  end
end
