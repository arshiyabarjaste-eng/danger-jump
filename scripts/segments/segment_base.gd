class_name SegmentBase
extends Node2D
## پایه‌ی همه‌ی قطعات مسیر: طول مشخص و آماده‌سازی با سرعت لحظه‌ای بازی

var length_px := 900.0

func prepare(_rng: RandomNumberGenerator, _speed: float) -> void:
	pass

func end_x() -> float:
	return global_position.x + length_px
