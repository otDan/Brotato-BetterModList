class_name CustomMenuMods
extends Control

signal back_button_pressed

export (PackedScene) var mod_container_scene

onready var _mod_list_container = $"%ModListContainer"
onready var _mod_info_container = $"%ModInfoContainer"
onready var _back_button = $"%BackButton"
onready var _mod_count_label = $"%ModCount"


func init()->void :
	_back_button.grab_focus()

	for n in _mod_list_container.get_children():
		_mod_list_container.remove_child(n)
		n.queue_free()

	var loaded_mod_count = 0
	var error_mod_count = 0
	for key in ModLoader.mod_data:
		var instance = mod_container_scene.instance()
		_mod_list_container.add_child(instance)
		instance.set_data(ModLoader.mod_data[key])
		var _error = instance.connect("mod_focused", self, "on_mod_focused")
		var _error_2 = instance.connect("mod_unfocused", self, "on_mod_unfocused")

		if ModLoader.mod_data[key].is_loadable:
			loaded_mod_count += 1
		else:
			error_mod_count += 1

	_mod_count_label.text = "Loaded: " + str(loaded_mod_count)

func on_mod_focused(mod:ModData)->void :
	_mod_info_container.set_data(mod)


func on_mod_unfocused(_mod:ModData)->void :
	_mod_info_container.set_empty()


func _on_BackButton_pressed()->void :
	emit_signal("back_button_pressed")


func _on_WorkshopButton_pressed()->void :
	Steam.activateGameOverlayToWebPage("https://steamcommunity.com/app/1942280/workshop/")
