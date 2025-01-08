extends CanvasLayer

func _ready() -> void:
	get_parent().win_game.connect(win)

func _on_resume_button_pressed() -> void:
	$UISFX.play()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$Options_Control.hide()
	self.hide()

func _on_options_button_pressed() -> void:
	$UISFX.play()
	$Options_Control.hide()
	$Audio_Control.show()

func _on_audio_button_pressed() -> void:
	$UISFX.play()
	$Audio_Control.hide()
	$Options_Control.show()

func _on_quit_button_pressed() -> void:
	$UISFX.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func win(amount):
	$Win_Control/Options_ColorRect/Cash_Label.text = "Total Cash: $ " + str(amount)

func _on_audio_scroll_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, log(value) * 10)
