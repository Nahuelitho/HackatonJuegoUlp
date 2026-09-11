extends StaticBody2D
# Ladrillo rompible - 1 tiro

func romper_muro(es_de_jugador: bool):
	# Avisa al gestor para contar
    	var gestor_bonus = get_node("/root/GestorBonus")
        	if gestor_bonus:
            		gestor_bonus.contar_muro_roto(global_position)
                    	queue_free()