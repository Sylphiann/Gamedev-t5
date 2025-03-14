extends CharacterBody2D

@export var SPEED := 200
@export var JUMP_SPEED := -400
@export var GRAVITY := 1200
@onready var animplayer = $AnimatedSprite2D

const UP = Vector2(0,-1)

func _get_input():
	# Jump
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_SPEED
		
	# Sprint
	if Input.is_key_pressed(KEY_CTRL):
		SPEED = 300
	else:
		SPEED = 200

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	var animation = "idle"
	if direction:
		animation = "jalan_kanan"
		velocity.x = direction * SPEED
		if direction>0:
			animplayer.flip_h = false
		else:
			animplayer.flip_h = true
	else:
		animation = "idle"
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if animplayer.animation!=animation:
		animplayer.play(animation)

	move_and_slide()


func _physics_process(delta: float) -> void:
	velocity.y += delta*GRAVITY
	_get_input()
	move_and_slide()
