extends AudioStreamPlayer2D

@onready var music: AudioStreamPlayer2D = $"."
@onready var level_song: AudioStreamPlayer2D = $LevelSong

func start_level_music():
	music.playing = false
	level_song.play()
