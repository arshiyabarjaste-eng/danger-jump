extends SegmentBase
## قطعه‌ی تخت بدون مانع — نفس‌گیری بین چالش‌ها

func _ready() -> void:
	length_px = 800.0
	SegmentBuilder.add_roof(self, 0.0, length_px)
