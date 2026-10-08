extends Node
## پخش افکت‌های صوتی و موسیقی پس‌زمینه با امکان قطع صدا و تنظیم بلندی

const SFX_PATHS := {
	"jump": "res://assets/audio/jump.wav",
	"land": "res://assets/audio/land.wav",
	"hit": "res://assets/audio/hit.wav",
	"pass": "res://assets/audio/pass.wav",
	"click": "res://assets/audio/click.wav",
	"game_over": "res://assets/audio/game_over.wav",
	"record": "res://assets/audio/record.wav",
}
const BGM_PATH := "res://assets/audio/bgm.wav"

var _sfx: Dictionary = {}
var _sfx_players: Array[AudioStreamPlayer] = []
var _bgm_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in 8:
		var p := AudioStreamPlayer.new()
		p.bus = "Master"
		add_child(p)
		_sfx_players.append(p)
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Master"
	add_child(_bgm_player)
	for key in SFX_PATHS:
		if ResourceLoader.exists(SFX_PATHS[key]):
			_sfx[key] = load(SFX_PATHS[key])
	if ResourceLoader.exists(BGM_PATH):
		var bgm: AudioStream = load(BGM_PATH)
		if bgm is AudioStreamWAV:
			bgm.loop_mode = AudioStreamWAV.LOOP_FORWARD
			bgm.loop_begin = 0
			bgm.loop_end = bgm.data.size() / 2  # 16-bit mono
		_bgm_player.stream = bgm
	apply_audio_settings()

func play(sfx_name: String, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	if SaveManager.muted or not _sfx.has(sfx_name):
		return
	for p in _sfx_players:
		if not p.playing:
			p.stream = _sfx[sfx_name]
			p.volume_db = volume_db
			p.pitch_scale = pitch
			p.play()
			return
	# همه‌ی پخش‌کننده‌ها مشغول‌اند؛ اولی را قطع کن
	_sfx_players[0].stream = _sfx[sfx_name]
	_sfx_players[0].volume_db = volume_db
	_sfx_players[0].pitch_scale = pitch
	_sfx_players[0].play()

func play_bgm() -> void:
	if _bgm_player.stream != null and not _bgm_player.playing:
		_bgm_player.volume_db = -16.0
		_bgm_player.play()

func stop_bgm() -> void:
	_bgm_player.stop()

func apply_audio_settings() -> void:
	var db := linear_to_db(clampf(SaveManager.volume, 0.0001, 1.0))
	AudioServer.set_bus_volume_db(0, db)
	AudioServer.set_bus_mute(0, SaveManager.muted)

func stream_count() -> int:
	return _sfx.size()
