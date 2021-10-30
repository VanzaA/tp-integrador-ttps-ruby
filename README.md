## Estructura

El proyecto cuenta con la siguiente estructura adentro de la carpeta polycon:

- Helpers: Carpeta donde se van a guardar diferentes utilidades que no corresponden a un metodo o modelo especifico, por ejemplo esta el archivo `file_system` que cuenta con diferentes utilidades para hacer todo el manejo de archivos necesarios
- Exceptions: Exepciones personalizadas para los modelos.
- Models: Modelos que contienen toda la logica de negocio necesaria para los diferentes comandos.

## Comandos

Se busco hacer los comandos los mas simple posible, por eso todos tienen la misma logica

```ruby
class Class < Dry::CLI::Command
  #...

  def call(args)
    Polycon::Models::ModelX.Method(args)
    puts "El metodo del modelo x funciono correctamente para los parametros #{args}"
  rescue Polycon::Exceptions::ModelX::Exception1,
          Polycon::Exceptions::ModelX::Exception2 => e
    warn e.message
  end
end
```

En un principio se trata de invocar al metodo del modelo correspondiente para realizar la accion necesaria. Si el modelo retorna correctamente, el comando termina imprimiendo algo confirmando que todo salio bien, si no, el mismo cuenta con el manejo de las posibles exepciones que puedan ocurrir durante la ejecucion, como por ejemplo, que no exista un profesional o una turno ya exista. Esta es la logica que se respeta en todos los comandos buscando hacer que sean funciones sencillas y la logica fuerte se encargue el modelo.

Los modelos cuentan con diferentes validaciones y si algo inesperado ocurre ejecutan exepciones que van a ser manejadas como se comento previamente.

Por el momento todo se resolvio con metodos de clase y no se hace uso de instancias.

## Codigo

Para respetar buenas practicas se agrego rubocop al proyecto como dependencia y se intento seguir las mayorias de las reglas definidas por el mismo (con algunas exepciones)

# Entrega 2

Se agrego el comando export dentro del prefijo appointments, el cual genera un archivo html con todos los turnos en formato tabla:

`polycon appointments export`

### Argumentos

- **date**: argumento obligatorio del cual se buscan los turnos, ejemplo 2021-11-14(fecha sin hora)-
- **professional**: opcional, nombre del profesional del cual se buscan los turnos para la fecha, si no se indica se busca para todos los profesionales. ejemplo: "alma estevez"
- **fullweek**: opcional, booleano que indica si se trae toda la semana o solo la fecha indicada. Tener en cuenta que la semana arrancara en domingo y termina en sabado. Si no se indica por defecto solo se busca para la fecha indicada
- **path**: opcional, es el path completo en donde se busca guardar el archivo generado. Si no se indica, se va a generar el archivo en la raiz de este proyecto.

Ejemplos:

- polycon appointments export "2021-09-16" --professional="Alma Estevez" --fullweek=true
- polycon appointments export "2021-09-16" --professional="Alma Estevez"
- polycon appointments export "2021-09-16"
- polycon appointments export "2021-09-16" --fullweek=true
- polycon appointments export "2021-09-16" --path="/home/user/table.html"

### Consideraciones:

Se asume que solo va a haber cargados turnos que terminen en 0, 15, 30 o 45 min, por ejemplo "2021-11-14 13:00.paf" "2021-11-14 13:15.paf" "2021-11-14 13:30.paf" "2021-11-14 13:40.paf".

El rango horario del cual se van a mostrar turnos va a ser todos los dias de 08:00 a 20:00 para reducir un poco el tamaño de la tabla.

La semana comienza en domingo siempre, entonces cuando se ponga la opcion fullweek va a comenzar la tabla en domingo y termina en sabado.

Si se indica un dia o una semana que no haya turnos, no se va a generar una tabla, va a imprimirse en la terminal un error: "No hay turnos registrados en esa fecha".

Si el profesional no existe, se imprimira un error "El profesional no existe".

Se espera que el path indicado sea valido y termine con nombre de archivo.

Para los horarios no exactos por ejemplo 15:11, van a ser ignorados.

Si se indica el argumento fullweek, no importa que fecha se indique, se busca obtener el principio de la semana. por ejemplo si se indica una fecha que cae viernes(2021/10/29), junto al argumento fullweek, se va a generar la tabla desde el dia domingo(2021/10/24) anterior al viernes, hasta el sabado(2021/10/30)

### Codigo

Para generar el HTML se utiliza ERB con un template el cual se encuentra en lib/polycon/template/calendar.html.erb

Se agrego varios metodos de instancia en el modelo de appointment, los cuales se utilizan en el template para mostrar los datos en la tabla.

Se agregaron 2 metodos en el helper de file_system para obtener los datos del template y exportarlo.

Primero se valida si se indico el profesional y si es valido, si no se obtienen todos los profesionales.
Luego se obtienen todos los turnos de los profesionales para el dia indicado, o toda la semana si se indico el fullweek.Por ultimo se genera el html utilizando el template de calendar.html.erb reemplazando con los datos obtenidos previamente.
