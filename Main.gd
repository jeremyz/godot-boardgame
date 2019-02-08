#warning-ignore-all:return_value_discarded
extends Node

func _ready():
	var cont = $"Hud/NinePatchRect/UnitContainer"
	cont.connect("dragging", $Map, "_on_dragging")
	$Map.connect("cancel_dragging", cont, "_on_cancel_dragging")
	$Map.connect("complete_dragging", cont, "_on_complete_dragging")

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()