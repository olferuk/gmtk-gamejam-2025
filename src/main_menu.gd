extends Control

func _on_new_game_button_pressed():
	LevelManager.load_level_1()
	get_tree().change_scene_to_file("res://scenes/ui/start_screen.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
