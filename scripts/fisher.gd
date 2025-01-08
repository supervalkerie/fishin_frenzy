extends Node2D

@onready var target: Sprite2D = $Target
@onready var marker: Sprite2D = $Marker

var inside:bool = false

signal end_fish_minigame

var random_frame:float = randf_range(0, 2)
var random_speed:float = randf_range(1, 3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target.position.x = randf_range(-450, 450)
	$AnimationPlayer.speed_scale = random_speed
	$AnimationPlayer.seek(random_frame)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and inside:
			end_fish_minigame.emit()

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("fish") and inside:
		#end_fish_minigame.emit()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	inside = true

func _on_area_2d_area_exited(_area: Area2D) -> void:
	inside = false
