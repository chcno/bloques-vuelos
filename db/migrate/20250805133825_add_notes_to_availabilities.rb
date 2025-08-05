class AddNotesToAvailabilities < ActiveRecord::Migration[8.0]
  def change
    add_column :availabilities, :notes, :text
  end
end
