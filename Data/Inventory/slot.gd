extends TextureRect

signal slot_enter(slot)
signal slot_exit(slot)

@onready var filter = $StatusFilter

var slot_id
var is_hovering := false

enum States{
	TAKEN,
	FREE,
	DEFAULT
}
var state = States.DEFAULT

var item_stored = null

func _process(delta):
	if get_global_rect().has_point(get_global_mouse_position()):
		if not is_hovering:
			is_hovering = true
			emit_signal("slot_enter", self)
	else:
		if is_hovering:
			is_hovering = false
			emit_signal("slot_exit", self)
	pass

func set_color(state = States.DEFAULT):
	match state:
		States.TAKEN:
			filter.color = Color(Color.RED, 0.2)
		States.FREE:
			filter.color = Color(Color.GREEN, 0.2)
		States.DEFAULT:
			filter.color = Color(Color.WHITE, 0.0)
	pass
