# Trabajo Bases de Datos

## Primeros pasos

Crea un archivo `Oracle.properties` similar a `Oracle.properties.example` con tus credenciales de Oracle.

## Ejecutar el programa

Para compilar:

```bash
./compile.bat
```

> Se compilará en el directorio `out/`.

Para ejecutar:

```bash
./run.bat
```

Con `-c` se borrará toda la BD y se volverá a crear y poblar.

```bash
./run.bat -c
```

## Comandos

Puedes poner cualquier comando SQL en la consola, y se ejecutará.

Para salir, escribe `exit`.

Puedes ejecutar un arhcivo SQL en la misma carpeta usando `./file.sql`.