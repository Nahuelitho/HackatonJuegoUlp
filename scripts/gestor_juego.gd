extends Node
# Gestor principal de la partida

signal enemigos_actualizados(restantes: int)
signal enemigo_eliminado(total_eliminados: int)
signal partida_finalizada(gano: bool)

const OBJETIVO_ENEMIGOS: int = 10
const ENEMIGOS_ANTES_DEL_JEFE: int = 9

var enemigos_eliminados: int = 0
var partida_terminada: bool = false
var finalizando_partida: bool = false

func iniciar_partida() -> void:
	enemigos_eliminados = 0
	partida_terminada = false
	finalizando_partida = false
	get_tree().paused = false
	enemigos_actualizados.emit(OBJETIVO_ENEMIGOS)

func jugador_murio() -> void:
	finalizar_con_demora(false)

func enemigo_muerto(era_jefe: bool = false) -> void:
	if partida_terminada or finalizando_partida:
		return
	enemigos_eliminados += 1
	var restantes = maxi(OBJETIVO_ENEMIGOS - enemigos_eliminados, 0)
	enemigos_actualizados.emit(restantes)
	enemigo_eliminado.emit(enemigos_eliminados)
	if era_jefe and enemigos_eliminados >= OBJETIVO_ENEMIGOS:
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

func aplicar_bonus_global(tipo: String) -> void:
	if tipo == "bomba_que_mata_todo":
		get_tree().call_group("enemigos", "recibir_danio", 10)
