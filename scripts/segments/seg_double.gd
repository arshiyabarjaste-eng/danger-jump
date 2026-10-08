extends SegmentBase
## قطعه‌ی تیغ دوقلو — دو مانع با فاصله‌ای که با یک پرش رد می‌شوند
## فاصله بر اساس سرعت لحظه‌ای محاسبه می‌شود تا همیشه قابل عبور باشد.

var spacing := 130.0

func prepare(_rng: RandomNumberGenerator, speed: float) -> void:
	spacing = clampf(speed * 0.30, 120.0, 220.0)

func _ready() -> void:
	length_px = 1050.0
	SegmentBuilder.add_roof(self, 0.0, length_px)
	var center := 560.0
	SegmentBuilder.add_spike(self, center - spacing * 0.5)
	SegmentBuilder.add_spike(self, center + spacing * 0.5)
