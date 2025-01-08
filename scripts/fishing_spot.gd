extends Node2D

var is_mouse_inside:bool
signal mouse_inside(is_mouse_inside)

signal on_fishing_spot_anim_finished
#var fish_spot_anim_finished:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("fishing_spot")

func _on_area_2d_mouse_entered() -> void:
	#is_mouse_inside = true
	mouse_inside.emit(true)

func _on_area_2d_mouse_exited() -> void:
	#is_mouse_inside = false
	mouse_inside.emit(false)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	#if anim_name = "fishing_spot"
	on_fishing_spot_anim_finished.emit()
