extends Area2D

var velocity = Vector2(0, -100)
var is_collected = false

@onready var anim_sprite = $AnimatedSprite2D
@onready var audio_player = $AudioStreamPlayer2D


func _ready():
	anim_sprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	if not is_collected:
		audio_player.play()
	is_collected = true


func _process(delta):
	if is_collected:
		velocity.y += gravity * delta
		global_position += velocity * delta

		if velocity.y > 0 and global_position.y >= position.y:
			await audio_player.finished
			queue_free()
