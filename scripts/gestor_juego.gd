extends Node
# Gestor principal oleadas y vidas

@export var prefab_enemigo: PackedScene
@export var puntos_spawn: Array[Marker2D>

var vidas_jugador: int = 3
var oleada: int = 1
var enemigos_vivos: int = 0
var max_enemigos_oleada: int = 4

func _ready():
	# Autoload como GestorJuego
    	iniciar_oleada()
        
        func iniciar_oleada():
        	enemigos_vivos = max_enemigos_oleada + oleada
            	for i in enemigos_vivos:
                		await get_tree().create_timer(0.8).timeout
                        		spawnear_enemigo()
                                
                                func spawnear_enemigo():
                                	if puntos_spawn.is_empty(): return
                                    	var punto = puntos_spawn.pick_random()
                                        	var ene = prefab_enemigo.instantiate()
                                            	ene.tipo = [0,1,2].pick_random() as int
                                                	get_tree().current_scene.add_child(ene)
                                                    	ene.global_position = punto.global_position
                                                        
                                                        func jugador_murio():
                                                        	vidas_jugador -= 1
                                                            	if vidas_jugador <= 0:
                                                                		juego_terminado(false)
                                                                        	else:
                                                                            		await get_tree().create_timer(1.5).timeout
                                                                                    		get_tree().reload_current_scene()
                                                                                            
                                                                                            func enemigo_muerto():
                                                                                            	enemigos_vivos -= 1
                                                                                                	if enemigos_vivos <= 0:
                                                                                                    		oleada += 1
                                                                                                            		iniciar_oleada()
                                                                                                                    
                                                                                                                    func juego_terminado(gano: bool):
                                                                                                                    	print("GAME OVER - Gano: ", gano)
                                                                                                                        	get_tree().paused = true
                                                                                                                            	# Acá mostrá tu UI de GameOver
                                                                                                                                
                                                                                                                                func aplicar_bonus_global(tipo: String):
                                                                                                                                	if tipo == "bomba_que_mata_todo":
                                                                                                                                    		get_tree().call_group("enemigos", "recibir_danio", 10)]