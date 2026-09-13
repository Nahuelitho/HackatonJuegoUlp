extends Area2D
# Bonus que spawnea GestorBonus

@export_enum("vida_extra", "escudo") var tipo: String = "vida_extra"

func _on_body_entered(cuerpo: Node) -> void:
	if not cuerpo.has_method("aplicar_bonus"):
		return
	cuerpo.aplicar_bonus(tipo)
	queue_free()
