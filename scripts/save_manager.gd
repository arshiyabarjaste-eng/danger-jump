extends Node
## مدیریت ذخیره‌سازی: بالاترین رکورد و تنظیمات صدا
## در برابر فایل ناموجود یا خراب مقاوم است و به پیش‌فرض برمی‌گردد.

const SAVE_PATH := "user://danger_jump_save.cfg"
const DEFAULT_VOLUME := 0.8

var high_score: int = 0
var muted: bool = false
var volume: float = DEFAULT_VOLUME

func _ready() -> void:
	load_data()

func load_data() -> void:
	high_score = 0
	muted = false
	volume = DEFAULT_VOLUME
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	if err != OK:
		# فایل خراب است؛ حذف و بازگشت به مقادیر پیش‌فرض
		push_warning("Save file corrupted, resetting: %s (error %d)" % [SAVE_PATH, err])
		DirAccess.remove_absolute(SAVE_PATH)
		return
	high_score = maxi(int(cfg.get_value("score", "high", 0)), 0)
	muted = bool(cfg.get_value("audio", "muted", false))
	volume = clampf(float(cfg.get_value("audio", "volume", DEFAULT_VOLUME)), 0.0, 1.0)

func save_data() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("score", "high", high_score)
	cfg.set_value("audio", "muted", muted)
	cfg.set_value("audio", "volume", volume)
	var err := cfg.save(SAVE_PATH)
	if err != OK:
		push_error("Could not save data: %s" % err)

## اگر رکورد جدید باشد true برمی‌گرداند
func submit_score(score: int) -> bool:
	if score > high_score:
		high_score = score
		save_data()
		return true
	return false

func set_audio(m: bool, v: float) -> void:
	muted = m
	volume = clampf(v, 0.0, 1.0)
	save_data()

func reset_all() -> void:
	high_score = 0
	save_data()
