extends Node2D

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200
var debounce_max : float = 3
var debounce : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()
	

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$Bird.reset()
	$background.region_rect.position.x = 0
	$game_over.visible = false

func _input(event: InputEvent) -> void:
	if game_over and debounce > 0: #== false: #we learned about guard clauses
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if game_running == false:
				if game_over:
					new_game()
				start_game()
			else:
				if $Bird.flying:
					$Bird.flap()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()

func bird_crash():
	game_over = true
	game_running = false
	debounce = debounce_max

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_over:
		$game_over.visible = true
		if debounce > 0:
			debounce -= delta
		return
		
	if game_running:
		scroll += SCROLL_SPEED
		
		if scroll >= screen_size.x:
			scroll = 0
			
		$background.region_rect.position.x = scroll
	
	
