# Golden Dogs

Juego 2D de tanques para Android desarrollado con Godot 4.7.2 durante una hackaton. Esta inspirado en Battle City/Tank 1990 y prioriza una experiencia simple, estable y presentable.

## Objetivo

El jugador controla un tanque y debe proteger una base fija. La partida termina en derrota si el jugador pierde sus 2 puntos de vida o si cualquier proyectil, incluso uno del jugador, destruye la base.

Para ganar hay que eliminar 9 tanques enemigos y luego derrotar al jefe final, que representa el objetivo numero 10.

## Tecnologia

- Godot Engine 4.7.2.
- GDScript, lenguaje de scripting propio de Godot con una sintaxis similar a Python.
- Escenas `.tscn` para árboles de nodos, propiedades y referencias a recursos.
- Recursos PNG para sprites y WAV para musica y efectos.
- Renderizador Compatibility para favorecer Android y equipos modestos.
- Resolucion logica horizontal de 1280x720.

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

## Reglas actuales

- Jugador: 2 vidas.
- Enemigo basico: 2 vidas.
- Jefe: 6 vidas, menor velocidad y disparos de potencia 2.
- Colisionar con un enemigo normal causa 1 de daño.
- Colisionar con el jefe causa 2 de daño.
- Ladrillo: 2 impactos normales; cambia visualmente después del primero.
- Acero: resiste disparos normales y se destruye con arma mejorada.
- Base: 1 impacto de cualquier proyectil produce derrota.
- Victoria: 9 enemigos básicos y luego el jefe.

## Estructura

```text
assets/     Graficos, musica y efectos de sonido
scenes/     Escenas reutilizables y pantallas
scripts/    Logica GDScript
project.godot
.project_context.md
```

Las escenas principales son:

- `scenes/menu_principal.tscn`: inicio, niveles y opciones.
- `scenes/nivel_prueba.tscn`: nivel jugable actual.
- `scenes/menu_pausa.tscn`: pausa, informacion y volumen.
- `scenes/jugador.tscn`, `enemigo.tscn` y `jefe.tscn`: tanques.
- `scenes/base_aguila.tscn`: objetivo que se debe proteger.

## Estado

El proyecto ya incluye menú, controles táctiles, jugador, disparos, muros, enemigos básicos, jefe, base, música, sonidos, explosiones, contador, vida, pausa y pantallas de victoria/derrota.

Todavía quedan por desarrollar o pulir la IA, bonus, niveles medio/difícil, cinemática, balance, persistencia de opciones y exportación Android.

## Contexto Para IA

Antes de continuar el desarrollo en una sesión nueva, compartir o pedir que se lea `.project_context.md`. Ese archivo contiene las decisiones vigentes, relaciones entre sistemas y siguiente trabajo recomendado.
