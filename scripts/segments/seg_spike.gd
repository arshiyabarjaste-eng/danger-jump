extends SegmentBase
## قطعه‌ی تیغ زمینی — پرش ساده روی تیغ

func _ready() -> void:
	length_px = 950.0
	SegmentBuilder.add_roof(self, 0.0, length_px)
	SegmentBuilder.add_spike(self, 560.0)
