class Professional < ApplicationRecord
  has_many :appointments, dependent: :destroy
  validates :name, uniqueness: { scope: :surname, message: "Ya existe un profesional con ese nombre y apellido" }

  def full_name
    "#{surname.capitalize}, #{name.capitalize}"
  end
end
