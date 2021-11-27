class User < ApplicationRecord
  authenticates_with_sorcery!

  enum role: {
    admin: 'admin',
    consultante: 'consultante',
    asistente: 'asistente'
  }

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
end
