class_name CustomModContainer
extends PanelContainer

signal mod_focused(mod_data)
signal mod_unfocused(mod_data)

var mod_data: ModData
var mod_style

onready var ListData = get_node("/root/ModLoader/otDan-BetterModList/ListData")
onready var Colors = get_node("/root/ModLoader/otDan-BetterModList/Colors")

onready var mod_name_button: Button = $"%ModNameButton"


func _ready():
	var style = get_stylebox("panel")
	mod_style = style.duplicate()
	add_stylebox_override("panel", mod_style)


func set_data(passed_mod: ModData) -> void:
	mod_data = passed_mod
	mod_name_button.text = mod_data.manifest.name
	mod_style.bg_color = ListData.get_color(passed_mod.manifest.get_mod_id())


func _on_ModName_focus_entered() -> void:
	emit_signal("mod_focused", mod_data)


func _on_ModName_mouse_entered() -> void:
	emit_signal("mod_focused", mod_data)


func _on_ModName_focus_exited() -> void:
	emit_signal("mod_unfocused", mod_data)
