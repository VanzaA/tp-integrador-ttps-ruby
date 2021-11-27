class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, presence: true, message: "La fecha es obligatoria"
  validates :name, presence: true, message: "El nombre del paciente es obligatorio"
  validates :surname, presence: true, message: "El apellido del paciente es obligatorio"
  validates :phone, presence: true, message: "El telefono es obligatorio"
  validates :date, uniqueness: { scope: :professional_id }, message: "Ya existe un turno para este profesional"

end
