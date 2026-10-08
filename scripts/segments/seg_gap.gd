extends SegmentBase
## قطعه‌ی حفره — شکاف بین دو پشت‌بام
## عرض حفره بر اساس سرعت لحظه‌ای محدود می‌شود تا همیشه قابل عبور باشد.

var gap_width := 160.0

func prepare(_rng: RandomNumberGenerator, speed: float) -> void:
	# حداکثر مسافت پرش = سرعت × زمان پرواز (۰٫۷۹ ثانیه)
	# ضریب ۰٫۴۶ حاشیه‌ی امن ~۳۵٪ برای خطای بازیکن نگه می‌دارد.
	gap_width = clampf(speed * 0.46, 150.0, 340.0)

func _ready() -> void:
	length_px = 1100.0
	var left_w := 350.0
	SegmentBuilder.add_roof(self, 0.0, left_w)
	SegmentBuilder.add_roof(self, left_w + gap_width, length_px - left_w - gap_width)
	SegmentBuilder.add_gap_deco(self, left_w, gap_width)
