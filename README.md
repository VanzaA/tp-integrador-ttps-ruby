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
