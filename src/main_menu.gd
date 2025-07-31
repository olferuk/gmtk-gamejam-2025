extends Control

@onready var accept_sound: AudioStreamPlayer2D = $AcceptSound
@onready var change_sound: AudioStreamPlayer2D = $ChangeSound
@onready var select_icon: Sprite2D = $SelectIcon

var selected_index := 0
var positions := [
	Vector2i(-18, 14),
	Vector2i(-18, 50),
]

func _on_new_game_button_pressed():
	start_new_game()

func _on_exit_button_pressed():
	exit_game()

func _unhandled_input(event):
	if event.is_action_pressed("ui_down") and selected_index == 0:
		change_sound.play()
		selected_index += 1
		_update_selection()
	elif event.is_action_pressed("ui_up") and selected_index == 1:
		change_sound.play()
		selected_index -= 1
		_update_selection()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		if selected_index == 0:
			start_new_game()
		else:
			exit_game()

func start_new_game():
	accept_sound.play()
	await accept_sound.finished
	get_tree().change_scene_to_file("res://scenes/menus/intro_splash.tscn")

func exit_game():
	get_tree().quit()

func _update_selection():
	select_icon.position = positions[selected_index]
