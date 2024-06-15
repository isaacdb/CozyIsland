extends AudioStreamPlayer2D

var music_general : AudioStream

func _ready():
	bus = "Music"
	pass
	
func set_playing(play: bool) -> void:
	playing = play;
	pass

func change_music(audio: AudioStream, finalVolume: int) -> void:
	if audio == stream and playing and finalVolume == volume_db:
		return
	
	volume_db = -100
	stream = audio
	
	play()
	
	var tween = create_tween()
	tween.tween_property(self, "volume_db", finalVolume, 1)
	tween.play()
	pass
	
func slow_down_stop(delay: int) -> void:
	var tweenStopCurrentTrack = create_tween()
	tweenStopCurrentTrack.tween_property(self, "volume_db", -30, delay)
	tweenStopCurrentTrack.play()	
	pass
