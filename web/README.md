# Notas a tener en cuenta.

Para el manejo de sesiones de usuario se utiliza la gema [sorcery](https://github.com/Sorcery/sorcery) y para la validacion de permisos se agrego [action_policy](https://github.com/palkan/action_policy).
Para los estilos del proyecto se uso [PicoCSS](https://picocss.com/)

Se preparo un seed el cual cuenta con 3 profesionales y 4 turnos por profesional (en total 12).
A su vez hay 3 usuarios para hacer pruebas:

```rb
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
```
Como se pueden observar, los 3 poseen de contraseña "password" y contienen un rol diferente cada uno.

Para cargar el seed es necesario ejecutar `rails db:seed`

Para la creacion de turnos solo se aceptan turnos cada de saltos de 15 min, por ejemplo 8:00, 8:15, 8:30 y 8:45. El horario para poder crear un turno es entre las 8 hs y las 20 hs.
En caso de que no haya turnos en una semana o un dia especificado cuando se intenta exportar el calendario, igualmente se genera un calendario vacio.

El proyecto se hizo pensado para mysql.