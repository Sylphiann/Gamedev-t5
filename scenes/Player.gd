extends CharacterBody2D

@export var walk_speed = 250
@export var jump_speed = -500
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Double jump variables
@export var max_jumps = 2
@export var jumps_left = max_jumps

# Double tap variables
@export var dashing_speed = 450
@export var dash_tap_interval = 0.25
@export var last_left_tap_time = 0
@export var last_right_tap_time = 0
@export var dash_slowdown_time = 1.0
@export var is_dashing = false
var dash_timer = 0.0

# Sprite node and Crouch variales
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@export var crouch_multiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Crouch sprite transformation
	if Input.is_action_pressed("ui_down"):
		sprite.scale.y = 0.75
		collision.scale.y = 0.75
	else:
		sprite.scale.y = 1.0
		collision.scale.y = 1.0


func _physics_process(delta):
	var speed = 0
	velocity.y += gravity * delta
	
	# Reset jumps when on the floor
	if is_on_floor():
		jumps_left = max_jumps

	# Jump logic
	if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
		velocity.y = jump_speed
		jumps_left -= 1
	
	# Smoothen jump velocity
	if velocity.y < 0 and Input.is_action_just_released("ui_up"):
		velocity.y *= 0.5
	
	if Input.is_action_pressed("ui_left"):
		speed = -1
		if Input.is_action_just_pressed("ui_left"):
			if Time.get_ticks_msec() / 1000.0 - last_left_tap_time< dash_tap_interval:
				is_dashing = true
				dash_timer = 0.0
			else:
				is_dashing = false
			last_left_tap_time = Time.get_ticks_msec() / 1000.0
			
	elif Input.is_action_pressed("ui_right"):
		speed =  1
		if Input.is_action_just_pressed("ui_right"):
			if Time.get_ticks_msec() / 1000.0 - last_right_tap_time< dash_tap_interval:
				is_dashing = true
				dash_timer = 0.0
			else:
				is_dashing = false
			last_right_tap_time = Time.get_ticks_msec() / 1000.0
		
	else:
		speed = 0
	
	# Crouch logic
	if Input.is_action_pressed("ui_down"):
		crouch_multiplier = 0.4
	else:
		crouch_multiplier = 1
		
	if speed != 0:
		if is_dashing:
			velocity.x = speed * dashing_speed * crouch_multiplier
			
			# Dash duration
			dash_timer += delta
			if dash_timer >= dash_slowdown_time:
				is_dashing = false
		else:
			velocity.x = speed * walk_speed * crouch_multiplier
	else:
		velocity.x = 0
		
	# "move_and_slide" already takes delta time into account.
	move_and_slide()
