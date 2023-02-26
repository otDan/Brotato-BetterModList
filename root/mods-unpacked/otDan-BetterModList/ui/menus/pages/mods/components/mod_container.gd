class_name CustomModContainer
extends PanelContainer

signal mod_focused(mod_data)
signal mod_unfocused(mod_data)

var mod_data:ModData

onready var _mod_name = $"%ModName" as RichTextLabel

onready var Colors = get_node("/root/ModLoader/otDan-BetterModList/Colors")

func set_data(p_mod:ModData)->void :
	mod_data = p_mod
	var mod_name: String
	if mod_data.is_loadable:
		mod_name += "[color=" + Colors.loaded + "]"
		mod_name += str(mod_data.manifest.name)
		mod_name += "[/color]"
	else:
		mod_name += "[color=" + Colors.unloaded + "]"
		mod_name += str(mod_data.manifest.name)
		mod_name += "[/color]"
	_mod_name.bbcode_text = mod_name


func _on_ModName_focus_entered()->void :
	emit_signal("mod_focused", mod_data)


func _on_ModName_mouse_entered()->void :
	emit_signal("mod_focused", mod_data)


func _on_ModName_focus_exited()->void :
	emit_signal("mod_unfocused", mod_data)