class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, presence: { message: "La fecha es obligatoria" }
  validates :name, presence: { message: "El nombre del paciente es obligatorio" }
  validates :surname, presence: { message: "El apellido del paciente es obligatorio" }
  validates :phone, presence: { message: "El telefono es obligatorio" }
  validates :date, uniqueness: { scope: :professional_id, message: "Ya existe un turno para este profesional" }

end
