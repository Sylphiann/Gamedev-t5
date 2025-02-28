# Tutorial 3 Game Development
Introduction to Game Programming

Nama : Favian Naufal  
NPM  : 2006597802

## Penjelasan fitur-fitur baru karakter dalam game platformer:

1. ***Double Jump***  

*Double jump* diimplementasikan dengan menggunakan kedua variable berikut.  

```
# Double jump variables
@export var max_jumps = 2
@export var jumps_left = max_jumps
```

Implementasi yang digunakan yaitu dengan menetapkan variable `max_jump` sebanyak dua kali, yang menandakan bahwa jumlah lompatan yang dapat dilakukan karakter di adalah dua kali: Dengan intuisi bahwa lompatan pertama di atas tanah, dan lompatan kedua saat berada di udara.  

Variable `jumps_left` menentukan jumlah lompatan tersisa yang dapat dilakukan karakter, variable in digunakan agar lompatan pertama di atas tanah mengurangi jatah lompatan karakter sebanyak satu, seperti cuplikan kode berikut ini.  

```
# Jump logic
if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
	velocity.y = jump_speed
	jumps_left -= 1
```

Tak dilupakan bahwa jatah lompatan yang dimiliki karakter kembali ter-*replenish* menjadi 2 ketika kembali atau saat menyentuh tanah

```
# Reset jumps when on the floor
if is_on_floor():
	jumps_left = max_jumps
```


2. ***Dashing***  

Logika *Dashing* yang dapat dilakukan karakter diimplementasikan dengan memberi interval kedapa karakter kapan 'terakhir kali pemain menekan *key* movement/panah kiri dana kanan', seperti yang ditunjukkan pada salah beberapa variable berikut.  

```
# Double tap variables
@export var dashing_speed = 450
@export var dash_tap_interval = 0.25
@export var last_left_tap_time = 0
@export var last_right_tap_time = 0
@export var dash_slowdown_time = 1.0
@export var is_dashing = false
var dash_timer = 0.0
```

Adapun *boolean* `is_dashing` yang sebagai penanda apakah karakter sedang melakukan *dashing*, serta durasi *dashing* karakter yang ditentukan sebanyak 1 detik. Berikut adalah logika yang diterapkan pada kode.  

```
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
```

3. ***Crouching***  

```
# Sprite node and Crouch variales
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@export var crouch_multiplier = 1
```

*Crouching* diimplemntasikan dengan mengurangi *speed* karakter dengan *multiplier* `0.4` ketika *key* ***down*** digunakan oleh pemain. Dengan logika kode berikut ini:

```
# Crouch logic
if Input.is_action_pressed("ui_down"):
	crouch_multiplier = 0.4
else:
	crouch_multiplier = 1
```

Adapun efek transformasi *scale* pada `Sprite2D` karakter yang berubah terhadap `y-scale` dengan multiplier `0.75` pada trigger *key* yang sama (***down***), pada cuplikan kode berikut ini yang diterapkan pada bagian `_process()`.

```
func _process(delta: float) -> void:
	# Crouch sprite transformation
	if Input.is_action_pressed("ui_down"):
		sprite.scale.y = 0.75
		collision.scale.y = 0.75
	else:
		sprite.scale.y = 1.0
		collision.scale.y = 1.0
```