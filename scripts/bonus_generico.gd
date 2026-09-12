extends Area2D
# Bonus que spawnea GestorBonus

@export var tipo: String = "vida_extra" # vida_extra, arma_mejorada, bomba_que_mata_todo, escudo

func _on_body_entered(cuerpo: Node) -> void:
	if not cuerpo.has_method("aplicar_bonus"):
		return
	if tipo == "bomba_que_mata_todo":
		var gestor_juego = get_node_or_null("/root/GestorJuego")
		if gestor_juego:
			gestor_juego.aplicar_bonus_global(tipo)
	else:
		cuerpo.aplicar_bonus(tipo)
	queue_free()
