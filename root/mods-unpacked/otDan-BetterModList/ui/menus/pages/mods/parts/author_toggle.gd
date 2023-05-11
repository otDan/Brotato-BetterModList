extends CheckBox

signal author_toggled(author, state)


func _ready():
	text = name


func _on_author_toggle_toggled(button_pressed):
	emit_signal("author_toggled", name, button_pressed)
