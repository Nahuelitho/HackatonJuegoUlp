extends Node

const MUSICA_PRINCIPAL = preload("res://assets/audio/musica/action game theme.wav")

var reproductor: AudioStreamPlayer

func _ready() -> void:
	reproductor = AudioStreamPlayer.new()
	reproductor.stream = MUSICA_PRINCIPAL
	reproductor.volume_db = -12.0
	reproductor.finished.connect(_repetir_musica)
	add_child(reproductor)
	reproductor.play()

func _repetir_musica() -> void:
	reproductor.play()

func _exit_tree() -> void:
	if is_instance_valid(reproductor):
		reproductor.stop()
		reproductor.stream = null
