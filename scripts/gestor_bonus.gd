extends Node
# Cuenta muros y spawnea bonus cada 4-8

@export var prefab_bonus: Array[PackedScene] # 0:vida, 1:arma, 2:bomba, 3:escudo

var muros_rotos: int = 0
var proximo_objetivo: int = 0

func _ready():
	randomize()
    	sortear_proximo_objetivo()
        	# Hacelo Autoload como GestorBonus

            func sortear_proximo_objetivo():
            	proximo_objetivo = randi_range(4, 8) # <-- TU PEDIDO: 4 a 8 random siempre
                	muros_rotos = 0
                    	print("Proximo bonus en: ", proximo_objetivo, " muros")

                        func contar_muro_roto(posicion: Vector2):
                        	muros_rotos += 1
                            	if muros_rotos >= proximo_objetivo:
                                		spawnear_bonus(posicion)
                                        		sortear_proximo_objetivo()

                                                func spawnear_bonus(pos: Vector2):
                                                	if prefab_bonus.is_empty(): return
                                                    	var tipo_random = randi() % prefab_bonus.size()
                                                        	var bonus = prefab_bonus[tipo_random].instantiate()
                                                            	get_tree().current_scene.add_child(bonus)
                                                                	bonus.global_position = pos