class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.date :date, null: false
      t.belongs_to :professional, null: false, foreign_key: true
      t.string :name, null: false
      t.string :surname, null: false
      t.string :phone, null: false
      t.text :notes

      t.timestamps
    end
  end
end
