extends CanvasLayer

func _ready():
	var us = load("res://unit/USUnit.tscn")
	var ge = load("res://unit/GEUnit.tscn")
	var tex = load("res://unit/assets/units.png")
	var unit
	var n = 0
	var cont = $NinePatchRect/UnitContainer
	for y in 3:
		for x in 4:
			if n < 6:
				unit = ge.instance()
			else:
				unit = us.instance()
			n += 1
			unit.set_body(x * 128, y * 128, 128, 128, tex)
			cont.add(unit, 64, 64)