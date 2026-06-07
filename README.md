# UNEFA Telecom Tools

El presente proyecto es una app de utilería para facilitar los cálculos realizados (tanto por profesores como por estudiantes más avanzados) de la carrera de Telecomunicaciones en la UNEFA Bejuma. A futuro, la app de utilería incluirá más funciones a medida que se vayan sondeando las necesidades comunes en cada asignatura.

## Desarrollo del proyecto.

La app no requiere conexión a internet y procura usar librerías muy básicas dentro de flutter, salvo las habituales como provider para mantener una gestión de estados reactiva en los formularios de entrada.

Se optó por emplear una arquitectura sencilla basada en:
- Un módulo de servicios, que encapsula la lógica de negocios desacoplada de la interfaz.
- Un módulo de controllers que llama a los servicios necesarios y se encarga de proveer los resultados a los componentes.
- Dentro de la UI un módulo de componentes: cada componente recoge información y presenta resultados, pero no almacena lógica en si mismo, la lógica es manejada por los controllers. A su vez, los componentes se renderizan en vistas (módulo `views/`), que actúan como orquestadores, no gestionan ni estados ni lógica (los estados son conservados por los componentes).

De esta forma, preparamos el camino para expandir y escalar la aplicación con mas funciones y vistas, sin que las vistas nuevas comprometan a las funcionalidades ya establecidas.

## Compilado (build from source)

Para compilar la apk, deben clonar el repositorio:

```bash
git clone https://github.com/gabrielbaute/unefa-telecom-tools.git
cd unefa-telecom-tools
```
Luego (deben tener instalado flutter y dart), ejecutamos:
```bash
flutter pub get
flutter build apk --release --split-per-abi
```
Encontrarán las apk dentro de la ruta `build/app/outputs/flutter-apk/` en el directorio de su proyecto.
## Editar la app

Si requieren agregar sus propias funciones o realizar cambios en el código, pueden usar `adb`, el `sdk` de android para desarrollar y algún emulador (yo he usado Pixel_5_API_34). Para el desarrollo no empleé Android Studio por ser muy pesado para mis pocos recursos, asi que usé directamente las herramientas de la terminal que provee Google. Debemos tener instalado `sdkmanager` de android (pueden bajarlo desde [aquí](https://developer.android.com/studio/command-line/sdkmanager))

```shell
sdkmanager "emulator" "system-images;android-34;google_apis;x86_64"
```

Este comando descargará el emulador y la imagen de Android 14 (API 34).
- `emulator` → instala el emulador base (~500 MB).
- `system-images` → instala la imagen de sistema (~1–2 GB).

Lo siguiente será crear un dispositivo virtual que flutter pueda usar:

```shell
avdmanager create avd -n Pixel_5_API_34 -k "system-images;android-34;google_apis;x86_64"
```

Una vez creado el dispositivo virtual, deberemos lanzarlo para que pueda estar disponible:

```shell
emulator -avd Pixel_5_API_34
```

`Pixel_5_API_34` es el nombre/id de nuestro dispositivo. Podremos ver el dispositivo ejecutando desde otra terminal:

```shell
flutter devices
flutter run -d # <--- con este comando ejecutaremos el proyecto, que compilará una apk y la instalará en nuestro dispositivo virtual
```
