extends Node2D

func _on_start_button_pressed() -> void:
	$ButtonSFX.play()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_button_pressed() -> void:
	$ButtonSFX.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
