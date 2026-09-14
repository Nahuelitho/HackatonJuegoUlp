# Golden Dogs

Juego 2D de tanques para Android desarrollado con Godot 4.7.2 durante una hackaton. Esta inspirado en Battle City/Tank 1990 y prioriza una experiencia simple, estable y presentable.

## Objetivo

El jugador controla un tanque y debe proteger una base fija. La partida termina en derrota si pierde todas sus vidas (3 en facil, 2 en medio y 1 en dificil) o si cualquier proyectil, incluso uno del jugador, destruye la base.

Para ganar hay que eliminar todos los tanques del nivel y luego derrotar al jefe final: 10 objetivos en facil, 15 en medio y 20 en dificil.

## Tecnologia

- Godot Engine 4.7.2.
- GDScript, lenguaje de scripting propio de Godot con una sintaxis similar a Python.
- Escenas `.tscn` para árboles de nodos, propiedades y referencias a recursos.
- Recursos PNG para sprites y WAV para musica y efectos.
- Renderizador Compatibility para favorecer Android y equipos modestos.
- Resolucion logica horizontal de 1280x720.
- Orientacion Android `sensor_landscape`: permite horizontal normal e invertida, pero nunca vertical. La interfaz se estira para ocupar todo el ancho de pantallas panoramicas.

## Requisitos

- Godot Engine 4.7.2 estable para editar y ejecutar el proyecto.
- Git para clonar y colaborar.
- Para exportar a Android: plantillas de exportacion de Godot, JDK y Android SDK configurados.

## Instalacion

1. Clonar el repositorio:

```bash
git clone https://github.com/Nahuelitho/HackatonJuegoUlp.git
```

2. Abrir el administrador de proyectos de Godot.
3. Elegir **Importar** y seleccionar `project.godot` dentro del repositorio.
4. Abrir el proyecto.
5. Ejecutar con `F5`.

La carpeta `.godot/` no se versiona; Godot la genera e importa los recursos automáticamente al abrir el proyecto por primera vez.

## Controles

### Android

- Cruceta tactil izquierda para moverse en cuatro direcciones.
- Boton de mira derecho para disparar.
- Boton `II` en la esquina superior derecha para pausar.

### PC para pruebas

- `WASD` o flechas para moverse.
- `Espacio` para disparar.
- `Escape` para abrir o cerrar la pausa.
- `Enter` o `Espacio` para avanzar los avisos y dialogos.

## Reglas actuales

- Jugador: 3 vidas en facil, 2 en medio y 1 en dificil.
- Enemigo basico: 2 vidas.
- Jefe: 6 vidas, menor velocidad y disparos pesados de potencia 2.
- El jefe se diferencia con rojo intenso; jugador amarillo y enemigos normales rojos.
- Colisionar con un enemigo normal causa 1 de daño.
- Colisionar con el jefe causa 2 de daño.
- Ladrillo: 2 impactos normales; cambia visualmente después del primero.
- Acero interior: resiste disparos normales y solo cede ante el fuego pesado del jefe.
- Acero de borde: medio bloque completamente irrompible.
- Agua: bloquea a los tanques, pero permite que las balas pasen por encima.
- Pasto: se dibuja por encima de los tanques sin bloquearlos.
- Herramientas cruzadas: recuperan 1 vida hasta el maximo de la dificultad.
- Escudo: muestra un aura celeste y absorbe el siguiente proyectil enemigo.
- Los bonus aparecen cada 3 a 7 ladrillos destruidos.
- Base: 1 impacto de cualquier proyectil produce derrota.
- Victoria: el jefe es siempre el ultimo objetivo; hay 10 objetivos en facil, 15 en medio y 20 en dificil.
- Victoria y derrota muestran el tiempo activo jugado en formato `mm:ss`, sin sumar las pausas.

## Estructura

```text
assets/     Graficos, musica y efectos de sonido
scenes/     Escenas reutilizables y pantallas
scripts/    Logica GDScript
project.godot
.project_context.md
```

Las escenas principales son:

- `scenes/aviso_historico.tscn`: aviso de contexto y ficcionalizacion previo al menu.
- `scenes/menu_principal.tscn`: inicio, niveles y opciones.
- `scenes/introduccion_historia.tscn`: contexto de la guerra, Port City y la misión de Golden Dogs.
- `scenes/cinematica_inicial.tscn`: dialogo entre Sgt. John y el Cabo antes del nivel facil iniciado desde el botón principal.
- `scenes/nivel_prueba.tscn`, `nivel_medio.tscn` y `nivel_dificil.tscn`: niveles jugables.
- `scenes/menu_pausa.tscn`: pausa, reinicio, guia con scroll, opciones y volumen.
- `scenes/jugador.tscn`, `enemigo.tscn` y `jefe.tscn`: tanques.
- `scenes/base_aguila.tscn`: objetivo que se debe proteger.

El flujo principal es: aviso historico, menu principal, introduccion narrativa, charla entre soldados, nivel facil y resultado. Ambas escenas narrativas permiten avanzar o saltar. El selector NIVELES abre la dificultad elegida sin reproducir las introducciones.

## Edicion del mapa

Cada dificultad tiene un mapa visualmente editable: `scenes/mapa_nivel_facil.tscn`, `scenes/mapa_nivel_medio.tscn` y `scenes/mapa_nivel_dificil.tscn`. Son autonomos: editar uno no modifica los otros. Los tres usan las mismas piezas de medio acero irrompible y esquinas rectas en sus bordes. Todos incluyen una guia visible solo en el editor. El mapa facil incluye una muestra de agua y una de pasto para mover o duplicar. Las piezas disponibles para arrastrar desde el panel **Sistema de archivos** son:

El boton principal `INICIAR JUEGO` reproduce la introduccion de Port City y luego la charla de los soldados antes del nivel facil. La seleccion directa desde `NIVELES` entra al mapa elegido sin repetir las escenas narrativas.

- `scenes/muro_ladrillo.tscn`: ladrillo completo con 2 vidas.
- `scenes/muro_ladrillo_danado.tscn`: pared ya dañada con 1 vida.
- `scenes/muro_acero.tscn`: acero completo; la propiedad `rompible` decide si el fuego pesado del jefe puede destruirlo.
- `scenes/muro_acero_medio_irrompible.tscn`: medio bloque de acero para bordes.
- `scenes/agua.tscn`: agua que bloquea tanques y deja pasar proyectiles.
- `scenes/pasto.tscn`: cobertura visual por encima de tanques y proyectiles, sin colision.

Para hacer vertical una pieza de medio acero, cambia su rotacion a `90` grados en el Inspector. No hace falta crear otro PNG: la escena usa solamente la mitad de `muro_acero.png` mediante `region_rect` y ajusta su colision al mismo tamaño.

Los mapas medio y dificil incluyen a la derecha una carpeta `PiezasParaEditar` con una muestra de ladrillo, pared dañada, medio ladrillo, acero, medio acero irrompible, agua y pasto. Esa paleta solo aparece en el editor y se oculta automáticamente al ejecutar.

## Estado

El proyecto ya incluye aviso historico, menu, cinematica con dos soldados animados por poses, tres niveles editables, controles tactiles, jugador, disparos, muros, agua, pasto, bonus de vida y escudo, enemigos basicos, jefe, base, musica, sonidos, explosiones, contador, cronometro, pausa y pantallas de victoria/derrota.

Todavía quedan por pulir el balance, la IA en configuraciones extremas, los dialogos adicionales de historia, la persistencia de opciones, las pruebas completas y la exportacion Android.

## Presentacion En Otra PC

1. Instalar o llevar Godot 4.7.2 estable.
2. Clonar el repositorio o copiar la carpeta completa del proyecto.
3. Importar `project.godot` y esperar a que Godot termine de importar imágenes, fuentes y sonidos.
4. Ejecutar con `F5`; la primera escena debe ser el aviso histórico.
5. Comprobar audio, resolución 1280x720, controles y pantalla completa antes de presentar.

No hace falta copiar la carpeta `.godot/`: se regenera automáticamente. Sí deben subirse todos los archivos nuevos dentro de `assets/`, `scenes/`, `scripts/`, además de `project.godot`, `Readme.md` y `.project_context.md`.

## Exportacion Android

1. Instalar las plantillas de exportacion de Godot 4.7.2 desde `Editor > Manage Export Templates`.
2. Configurar JDK 17 y Android SDK en `Editor Settings > Export > Android`.
3. Abrir `Proyecto > Exportar`, agregar un preset Android y definir un identificador unico, por ejemplo `com.goldendogs.game`.
4. Exportar un APK de depuracion para probar o un APK/AAB firmado para distribuir.
5. Verificar en un telefono real la orientacion horizontal, botones tactiles, audio, textos largos, scroll y rendimiento.

El proyecto ya fuerza orientación horizontal, conserva el aspecto 16:9 y permite usar botones normales de UI mediante entrada táctil. `export_presets.cfg` se genera desde el editor al crear el preset Android y puede variar según el SDK o firma de cada computadora.

## Contexto Para IA

Antes de continuar el desarrollo en una sesión nueva, compartir o pedir que se lea `.project_context.md`. Ese archivo contiene las decisiones vigentes, relaciones entre sistemas y siguiente trabajo recomendado.
