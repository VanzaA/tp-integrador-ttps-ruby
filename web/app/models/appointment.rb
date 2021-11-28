class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, presence: { message: "La fecha es obligatoria" }
  validates :name, presence: { message: "El nombre del paciente es obligatorio" }
  validates :surname, presence: { message: "El apellido del paciente es obligatorio" }
  validates :phone, presence: { message: "El telefono es obligatorio" }
  validates :date, uniqueness: { scope: :professional_id, message: "Ya existe un turno para este profesional" }
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    if date.present? && date < DateTime.now
      errors.add(:date, "El turno no puede ser asignado a una fecha y hora menor a la actual")
    end
  end
end
