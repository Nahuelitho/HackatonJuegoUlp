extends StaticBody2D
# Base a defender

@export var vida: int = 1
var destruida: bool = false

func romper_muro(_es_jugador: bool = false, _arma_mejorada: bool = false) -> void:
	if destruida:
		return
	destruida = true
	vida -= 1
	if vida <= 0:
		var gestor_juego = get_node_or_null("/root/GestorJuego")
		if gestor_juego:
			gestor_juego.juego_terminado(false)
		queue_free()
