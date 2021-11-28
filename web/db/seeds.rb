# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

MOCK_TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam malesuada pretium libero nec eleifend. Sed sed dolor feugiat, mollis tortor at, vestibulum enim. Cras aliquam lorem sed urna congue ultricies. Nullam pellentesque, nulla ut elementum dictum, dolor ipsum cursus nibh, id interdum ligula ante in erat. Nulla varius purus vel purus vehicula, vitae molestie felis posuere. Nam ac facilisis purus, in fermentum ipsum. Proin aliquet tellus at metus condimentum, id ultrices leo tempus. Fusce nulla dolor, condimentum non porttitor eget, vulputate sed arcu."

User.find_or_create_by(email: 'admin@example.com') do |user|
  user.password = 'password'
  user.role = :admin
end

User.find_or_create_by(email: 'consultante@example.com') do |user|
  user.password = 'password'
  user.role = :consultante
end

User.find_or_create_by(email: 'asistente@example.com') do |user|
  user.password = 'password'
  user.role = :asistente
end

professional1 = Professional.find_or_create_by(name: "alma", surname: "esteves")
professional2 = Professional.find_or_create_by(name: "juan", surname: "carlos")
professional3 = Professional.find_or_create_by(name: "alberto", surname: "martines")

Appointment.find_or_create_by(date: (DateTime.now + 1.days).change({ hour: 12, min: 15}), professional_id: professional1.id) do |appointment|
 appointment.name = "Jorge"
 appointment.surname = 11111222333
 appointment.phone = 11111222333
end

Appointment.find_or_create_by(date: (DateTime.now + 1.days).change({ hour: 14, min: 15}), professional_id: professional1.id) do |appointment|
  appointment.name = "Maria"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
  appointment.notes = MOCK_TEXT
end

#
Appointment.find_or_create_by(date: (DateTime.now + 2.days).change({ hour: 13, min: 45}), professional_id: professional1.id) do |appointment|
  appointment.name = "Isabel"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
  appointment.notes = MOCK_TEXT
end
#
Appointment.find_or_create_by(date: (DateTime.now + 1.days).change({ hour: 16, min: 15}), professional_id: professional1.id) do |appointment|
  appointment.name = "Juana"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
  appointment.notes = MOCK_TEXT
end
#
Appointment.find_or_create_by(date: (DateTime.now + 3.days).change({ hour: 18, min: 15}), professional_id: professional2.id) do |appointment|
  appointment.name = "Lucas"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
end

Appointment.find_or_create_by(date: (DateTime.now + 1.days).change({ hour: 9, min: 30}), professional_id: professional2.id) do |appointment|
  appointment.name = "Martin"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
  appointment.notes = MOCK_TEXT
end

Appointment.find_or_create_by(date: (DateTime.now + 1.days).change({ hour: 12, min: 15}), professional_id: professional2.id) do |appointment|
  appointment.name = "Marta"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
end
#
Appointment.find_or_create_by(date: (DateTime.now + 5.days).change({ hour: 15, min: 15}), professional_id: professional2.id) do |appointment|
  appointment.name = "Diego"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
end

Appointment.find_or_create_by(date: (DateTime.now + 1.days).change({ hour: 12, min: 15}), professional_id: professional3.id) do |appointment|
  appointment.name = "Cris"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
  appointment.notes = MOCK_TEXT
end
#
Appointment.find_or_create_by(date: (DateTime.now + 2.days).change({ hour: 18, min: 0}), professional_id: professional3.id) do |appointment|
  appointment.name = "Benjamin"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
end
#
Appointment.find_or_create_by(date: (DateTime.now + 6.days).change({ hour: 19, min: 15}), professional_id: professional3.id) do |appointment|
  appointment.name = "Ines"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
  appointment.notes = MOCK_TEXT
end
#
Appointment.find_or_create_by(date: (DateTime.now + 6.days).change({ hour: 11, min: 15}), professional_id: professional3.id) do |appointment|
  appointment.name = "Lautaro"
  appointment.surname = 11111222333
  appointment.phone = 11111222333
  appointment.notes = MOCK_TEXT
end