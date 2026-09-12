extends AnimatedSprite2D

func _ready() -> void:
	play("explotar")
	$Sonido.play()
	await animation_finished
	visible = false
	await $Sonido.finished
	queue_free()
