extends Node2D

var FISH_INSTANCE = preload("res://scenes/fish.tscn")
var FISH_MINIGAME = preload("res://scenes/fisher.tscn")
var FISH_SPOT = preload("res://scenes/fishing_spot.tscn")
const WIN_MUSIC = preload("res://assets/audio/the_reel_winner_by_memoraphile_CC0.mp3")

signal win_game(cash_total:float)

var fish:Node2D
var fish_minigame:Node2D

var fishing_spot:Node2D
var fishing_spot_position:Vector2
var inside_fishing_spot:bool = false

var can_fish:bool = true

var cash:float = 0

var random_fish_time:float

# sfx, start screen, options menu, end screen, pixel boat in background?, win condition
# random speed/difficulty for fisher animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	generate_fish()
	generate_fishing_spot()
	
func _process(_delta: float) -> void:
	#print(inside_fishing_spot)
	pass

func generate_fishing_spot():
	print("Generating Fishing Spot")
	fishing_spot_position = Vector2(randf_range(-500, 500), randf_range(-250, 250))
	fishing_spot = FISH_SPOT.instantiate()
	add_child(fishing_spot)
	fishing_spot.position = fishing_spot_position
	fishing_spot.connect("mouse_inside", fished_spot)
	fishing_spot.connect("on_fishing_spot_anim_finished", reset_fishing_spot)

# Determine if Mouse is inside fishing_spot by bool check with signals on fishing_spot
func fished_spot(mouse_in:bool):
	inside_fishing_spot = mouse_in

# Instantiate and generate a new fish, hide it, and set a random fish time
func generate_fish():
	print("Generating Fish")
	fish = FISH_INSTANCE.instantiate()
	add_child(fish)
	fish.hide()
	random_fish_time = randf_range(1, 4)

# Check Inputs
func _input(event: InputEvent) -> void:
# Check Left Click and Mouse is inside Fishing_Spot -> find_fish()
	if can_fish:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and inside_fishing_spot:
				$SplashSFX.play()
				can_fish = false
				inside_fishing_spot = false
				find_fish()
				#reset_fishing_spot()
				if is_instance_valid(fishing_spot):
					fishing_spot.queue_free()

# Options menu
	if event.is_action_pressed("quit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$UI.show()
		$UI/Options_Control.show()
	
# Reset game
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

# Simple timer for "finding fish", just wait a random time, hide/show fishing ui, then start fishing game
func find_fish():
	$Cursor.hide()
	$UI.show()
	$UI/Fishing_Control.show()
	await get_tree().create_timer(random_fish_time).timeout
	$UI.hide()
	$UI/Fishing_Control.hide()
	start_fish_minigame()

func start_fish_minigame():
	fish_minigame = FISH_MINIGAME.instantiate()
	add_child(fish_minigame)
	$ReelSFX.play()
	fish_minigame.connect("end_fish_minigame", end_fish_minigame)

func end_fish_minigame():
	print("caught!")
	$ReelSFX.stop()
	fish_minigame.queue_free()
	fish.show()
	fish.play_anim()
	cash += fish.fish_price
	$CashParticles.emitting = true
	$CashLabel.text = "Cash: $" + str(cash)
	await get_tree().create_timer(5).timeout
	if cash >= 100:
		win()
		return
	reset_state()
	
func reset_state():
	print("Resetting state")
	fish.queue_free()
	$Cursor.show()
	generate_fish()
	generate_fishing_spot()
	can_fish = true

func reset_fishing_spot():
	print("Resetting Fishing Spot")
	if is_instance_valid(fishing_spot):
		fishing_spot.queue_free()
	#fishing_spot = null
	await get_tree().create_timer(1).timeout
	generate_fishing_spot()

func win():
	print("Congrats! Your're Winner")
	win_game.emit(cash)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$UI.show()
	$UI/Win_Control.show()
	$FishinMusic.stop()
	$WinMusic.play()
