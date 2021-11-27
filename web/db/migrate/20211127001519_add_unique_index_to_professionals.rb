class AddUniqueIndexToProfessionals < ActiveRecord::Migration[6.1]
  def change
    add_index :professionals, [:name, :surname], unique: true
  end
end
