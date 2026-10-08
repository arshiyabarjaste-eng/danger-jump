extends SegmentBase
## قطعه‌ی مانع بلند — کولر آبی روی پشت‌بام که باید از رویش پرید

func _ready() -> void:
	length_px = 950.0
	SegmentBuilder.add_roof(self, 0.0, length_px)
	SegmentBuilder.add_ac(self, 580.0)
