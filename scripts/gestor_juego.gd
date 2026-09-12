extends Node
# Gestor principal de la partida

@export var prefab_enemigo: PackedScene
@export var puntos_spawn: Array[Marker2D]
@export var objetivo_enemigos: int = 10

var enemigos_eliminados: int = 0
var partida_terminada: bool = false

func jugador_murio() -> void:
	juego_terminado(false)

func enemigo_muerto() -> void:
	if partida_terminada:
		return
	enemigos_eliminados += 1
	print("Enemigos eliminados: ", enemigos_eliminados, "/", objetivo_enemigos)
	if enemigos_eliminados >= objetivo_enemigos:
		juego_terminado(true)

func juego_terminado(gano: bool) -> void:
	if partida_terminada:
		return
	partida_terminada = true
	print("GAME OVER - Gano: ", gano)
	get_tree().paused = true

func reiniciar_partida() -> void:
	partida_terminada = false
	enemigos_eliminados = 0
	get_tree().paused = false
	get_tree().reload_current_scene()

func aplicar_bonus_global(tipo: String) -> void:
	if tipo == "bomba_que_mata_todo":
		get_tree().call_group("enemigos", "recibir_danio", 10)
