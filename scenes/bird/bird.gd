extends CharacterBody2D


const GRAVITY : int = 1000#500
const MAX_VEL : int = 500#600(debug:200)
const FLAP_SPEED : int = -400#-500(debug:-200)
var flying : bool = false
var falling : bool = false
const START_POS = Vector2(100, 400)
var dead : bool = false

func _read():
	reset()

func reset():
	falling = false
	flying = false
	dead = false
	position = START_POS
	set_rotation(0)

func _physics_process(delta: float) -> void:
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	if dead:
		return
		
	if flying or falling:
		velocity.y += GRAVITY * delta
	
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()
	
	if position.y >= get_window().size.y:
		get_parent().bird_crash()
		dead = true

func flap():
	velocity.y = FLAP_SPEED
