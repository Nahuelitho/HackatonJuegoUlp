extends StaticBody2D
# Base a defender

const EXPLOSION = preload("res://scenes/explosion.tscn")

@export var vida: int = 1
var destruida: bool = false

func romper_muro(_es_jugador: bool = false, _impacto_fuerte: bool = false) -> void:
	if destruida:
		return
	destruida = true
	vida -= 1
	if vida <= 0:
		var explosion = EXPLOSION.instantiate()
		get_tree().current_scene.add_child(explosion)
		explosion.global_position = global_position
		var gestor_juego = get_node_or_null("/root/GestorJuego")
		if gestor_juego:
			gestor_juego.finalizar_con_demora(false)
		queue_free()
