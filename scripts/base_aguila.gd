extends StaticBody2D
# Base a defender

@export var vida: int = 1

func romper_muro(_es_jugador: bool = false):
	vida -= 1
    	if vida <= 0:
        		get_node("/root/GestorJuego").juego_terminado(false)
                		queue_free()