# proyecto_v2

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado Flutter y Dart en tu máquina. Para conectarlo a la base de datos puedes crear cualquier proyecto a tu cuenta de firebase, realizar los siguientes pasos

1. Instalar firebase CLI
2. firebase login
3. dart pub global activate flutterfire_cli
4. flutterfire configure

Seleccionas el proyecto que creaste en firebase y lo demás se hace solo.

## Configuración del Proyecto

1. Clona este repositorio en tu máquina local:

    ```bash
    git clone https://github.com/Angelveb/ProyectoFinal
    ```

2. Navega al directorio del proyecto:

    ```bash
    cd (Dirección de donde sea que hayas guardado el proyecto en tu pc)
    ```

3. Ejecuta el siguiente comando para obtener las dependencias:

    ```bash
    flutter pub get
    ```

## Ejecutar la Aplicación

Una vez que hayas configurado el proyecto, puedes ejecutar la aplicación con el siguiente comando:

```bash
flutter run

## Por si tienes algun problema, ejecuta los dos siguientes comandos

Actualiza todas las dependencias
flutter pub upgrade

El siguiente comando verifica su entorno y muestra un informe del estado de su instalación de Flutter. Verifique el resultado cuidadosamente para ver si hay otro software que pueda necesitar instalar o realizar más tareas (que se muestran en negrita )
flutter doctor
