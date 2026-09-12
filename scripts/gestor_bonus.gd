extends Node
# Cuenta muros y spawnea bonus cada 4-8

@export var prefab_bonus: Array[PackedScene] # 0:vida, 1:arma, 2:bomba, 3:escudo

var muros_rotos: int = 0
var proximo_objetivo: int = 0

func _ready() -> void:
	randomize()
	sortear_proximo_objetivo()

func sortear_proximo_objetivo() -> void:
	proximo_objetivo = randi_range(4, 8)
	muros_rotos = 0
	print("Proximo bonus en: ", proximo_objetivo, " muros")

func contar_muro_roto(posicion: Vector2) -> void:
	muros_rotos += 1
	if muros_rotos >= proximo_objetivo:
		spawnear_bonus(posicion)
		sortear_proximo_objetivo()

func spawnear_bonus(pos: Vector2) -> void:
	if prefab_bonus.is_empty():
		return
	var tipo_random = randi() % prefab_bonus.size()
	var bonus = prefab_bonus[tipo_random].instantiate()
	get_tree().current_scene.add_child(bonus)
	bonus.global_position = pos
