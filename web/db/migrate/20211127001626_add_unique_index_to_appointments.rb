class AddUniqueIndexToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_index :appointments, [:date, :time, :professional_id], unique: true
  end
end
