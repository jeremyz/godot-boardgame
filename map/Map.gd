#warning-ignore-all:return_value_discarded
extends Node2D

signal on_gesture(param)
signal cancel_dragging(unit)
signal complete_dragging(unit)

var dragging = false

func _ready():
	$Camera.configure_with($Sprite)
	$Camera.current = true
	$Camera.drag_margin_h_enabled = false
	$Camera.drag_margin_v_enabled = false
	connect("on_gesture", $Camera, "_on_gesture")

func _unhandled_input(event):
	if event is InputEventMagnifyGesture:
		emit_signal("on_gesture", "magnify", event.factor)
	elif event is InputEventPanGesture:
		emit_signal("on_gesture", "drag", event.delta)
	elif dragging and event is InputEventMouseMotion:
		emit_signal("on_gesture", "drag", event.relative)
	elif event is InputEventMouseButton:
		if event.is_pressed():
			dragging = true
			var bx = event.button_index 
			if   bx == BUTTON_RIGHT:
				emit_signal("on_gesture", "home", 0)
			elif bx == BUTTON_LEFT:
				emit_signal("on_gesture", "move_to", get_global_mouse_position())
			elif bx == BUTTON_WHEEL_UP:
				emit_signal("on_gesture", "zoom_in_to", get_global_mouse_position())
			elif bx == BUTTON_WHEEL_DOWN:
				emit_signal("on_gesture", "zoom_out_from", get_global_mouse_position())
		else:
			dragging = false

# from UnitContainer
func _on_dragging(unit : Unit):
	add_child(unit)
	unit.scale = Vector2(1, 1)
	unit.set_dragging()
	unit.connect("dropped_in", self, "_on_dropped_in")
	unit.connect("dropped_out", self, "_on_dropped_out")

# from Unit
func _on_dropped_in(unit : Unit):
	# remove_child(unit)
	# drop_zone.add_child(unit)
	emit_signal("complete_dragging", unit)
	disconnect_unit(unit)

# from Unit
func _on_dropped_out(unit : Unit):
	remove_child(unit)
	emit_signal("cancel_dragging", unit)
	disconnect_unit(unit)

func disconnect_unit(unit : Unit):
	unit.disconnect("dropped_in", self, "_on_dropped_in")
	unit.disconnect("dropped_out", self, "_on_dropped_out")