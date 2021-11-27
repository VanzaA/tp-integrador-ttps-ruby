class Professional < ApplicationRecord
  validates :name, uniqueness: { scope: :surname }, message: "Ya existe un profesional con ese nombre"
end
