extends StaticBody2D

@export var vida: int = 2

@onready var sprite: Sprite2D = $Sprite2D

func romper_muro(_es_de_jugador: bool, arma_mejorada: bool = false) -> void:
	vida -= 2 if arma_mejorada else 1
	if vida > 0:
		sprite.modulate = Color(0.72, 0.55, 0.55, 1.0)
		return

	var gestor_bonus = get_node_or_null("/root/GestorBonus")
	if gestor_bonus:
		gestor_bonus.contar_muro_roto(global_position)
	queue_free()
