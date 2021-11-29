class Appointment < ApplicationRecord
  belongs_to :professional
  validates :date, presence: { message: "La fecha es obligatoria" }
  validates :time, presence: { message: "La hora es obligatoria" }
  validates :name, presence: { message: "El nombre del paciente es obligatorio" }
  validates :surname, presence: { message: "El apellido del paciente es obligatorio" }
  validates :phone, presence: { message: "El telefono es obligatorio" }
  validates :phone, numericality: { only_integer: true, message: "El telefono tiene que contener solo numeros" }
  validates :date, uniqueness: { scope: [:time, :professional_id], message: "Ya existe un turno para este profesional" }
  validate :date_cannot_be_in_the_past
  validate :minute_step

  private
  def minute_step
    return unless date_and_time_present

    steps = ["00", "15", "30", "45"]
    minutes = time.strftime("%M")
    unless steps.include? (minutes)
      errors.add(:time, "La hora tiene que ser de saltos de 15 minutos")
    end
  end

  def date_cannot_be_in_the_past
    return unless date_and_time_present

    datetime = date.to_datetime + time.seconds_since_midnight.seconds + 3.hours
    if datetime < DateTime.now.utc
      errors.add(:date, "El turno no puede ser asignado a una fecha y hora menor a la actual")
    end
  end

  def date_and_time_present
    time.present? && date.present?
  end
end
