class_name CustomModContainer
extends PanelContainer

signal mod_focused(mod_data)
signal mod_unfocused(mod_data)

var mod_data:ModData
var mod_style

onready var Colors = get_node("/root/ModLoader/otDan-BetterModList/Colors")
onready var mod_name_button: Button = $"%ModNameButton"


func _ready():
	var style = get_stylebox("panel")
	mod_style = style.duplicate()
	add_stylebox_override("panel", mod_style)


func set_data(p_mod:ModData)->void:
	mod_data = p_mod
	mod_name_button.text = mod_data.manifest.name
	if mod_data.is_loadable:
		mod_style.bg_color = Color(Colors.loaded)
	else:
		mod_style.bg_color = Color(Colors.unloaded)


func _on_ModName_focus_entered()->void:
	emit_signal("mod_focused", mod_data)


func _on_ModName_mouse_entered()->void:
	emit_signal("mod_focused", mod_data)


func _on_ModName_focus_exited()->void:
	emit_signal("mod_unfocused", mod_data)
