class Professional < ApplicationRecord
  validates :name, uniqueness: { scope: :surname, message: "Ya existe un profesional con ese nombre y apellido" }

  def full_name
    "#{surname}, #{name}"
  end
end
