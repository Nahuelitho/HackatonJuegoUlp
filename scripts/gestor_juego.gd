extends Node
# Gestor principal de la partida

signal enemigos_actualizados(restantes: int)
signal enemigo_eliminado(total_eliminados: int)
signal partida_finalizada(gano: bool)

enum Dificultad { FACIL, MEDIO, DIFICIL }

var dificultad: int = Dificultad.FACIL

var enemigos_eliminados: int = 0
var partida_terminada: bool = false
var finalizando_partida: bool = false

func seleccionar_dificultad(nueva_dificultad: int) -> void:
	dificultad = nueva_dificultad

func obtener_vidas_iniciales() -> int:
	match dificultad:
		Dificultad.FACIL:
			return 3
		Dificultad.MEDIO:
			return 2
		_:
			return 1

func obtener_objetivo_enemigos() -> int:
	match dificultad:
		Dificultad.MEDIO:
			return 15
		Dificultad.DIFICIL:
			return 20
		_:
			return 10

func obtener_ruta_mapa() -> String:
	match dificultad:
		Dificultad.MEDIO:
			return "res://scenes/mapa_nivel_medio.tscn"
		Dificultad.DIFICIL:
			return "res://scenes/mapa_nivel_dificil.tscn"
		_:
			return "res://scenes/mapa_nivel_facil.tscn"

func obtener_ruta_nivel() -> String:
	match dificultad:
		Dificultad.MEDIO:
			return "res://scenes/nivel_medio.tscn"
		Dificultad.DIFICIL:
			return "res://scenes/nivel_dificil.tscn"
		_:
			return "res://scenes/nivel_prueba.tscn"

func iniciar_partida() -> void:
	enemigos_eliminados = 0
	partida_terminada = false
	finalizando_partida = false
	get_tree().paused = false
	enemigos_actualizados.emit(obtener_objetivo_enemigos())

func jugador_murio() -> void:
	finalizar_con_demora(false)

func enemigo_muerto(era_jefe: bool = false) -> void:
	if partida_terminada or finalizando_partida:
		return
	enemigos_eliminados += 1
	var objetivo := obtener_objetivo_enemigos()
	var restantes = maxi(objetivo - enemigos_eliminados, 0)
	enemigos_actualizados.emit(restantes)
	enemigo_eliminado.emit(enemigos_eliminados)
	if era_jefe and enemigos_eliminados >= objetivo:
		finalizar_con_demora(true)

func finalizar_con_demora(gano: bool, demora: float = 1.2) -> void:
	if partida_terminada or finalizando_partida:
		return
	finalizando_partida = true
	await get_tree().create_timer(demora).timeout
	finalizando_partida = false
	juego_terminado(gano)

func juego_terminado(gano: bool) -> void:
	if partida_terminada:
		return
	partida_terminada = true
	partida_finalizada.emit(gano)
	get_tree().paused = true

func reiniciar_partida() -> void:
	iniciar_partida()
	get_tree().paused = false
	get_tree().reload_current_scene()
