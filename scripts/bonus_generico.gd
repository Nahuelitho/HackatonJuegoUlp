extends Area2D
# Bonus que spawnea GestorBonus

@export var tipo: String = "vida_extra" # vida_extra, arma_mejorada, bomba_que_mata_todo, escudo

func _on_body_entered(cuerpo):
	if not cuerpo.has_method("aplicar_bonus"): return
    	if tipo == "bomba_que_mata_todo":
        		get_node("/root/GestorJuego").aplicar_bonus_global(tipo)
                	else:
                    		cuerpo.aplicar_bonus(tipo)
                            	queue_free()