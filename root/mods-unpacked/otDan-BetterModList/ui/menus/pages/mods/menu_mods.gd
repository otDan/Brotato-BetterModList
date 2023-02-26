class_name CustomMenuMods
extends Control

signal back_button_pressed

export (PackedScene) var mod_container_scene
export (PackedScene) var mod_author_toggle

var authors_dictionary: Dictionary

onready var _author_container = $"%AuthorContainer"
onready var _mod_list_container = $"%ModListContainer"
onready var _mod_info_container = $"%ModInfoContainer"
onready var _back_button = $"%BackButton"
onready var _mod_loaded_count_label = $"%LoadedModCount"
onready var _mod_disabled_count_label = $"%DisabledModCount"

func init()->void:
	_back_button.grab_focus()

	for n in _mod_list_container.get_children():
		_mod_list_container.remove_child(n)
		n.queue_free()

	var loaded_mod_count = 0
	var error_mod_count = 0

	for mod in ModLoader.mod_data:
		var instance = mod_container_scene.instance()
		_mod_list_container.add_child(instance)
		var mod_data = ModLoader.mod_data[mod]
		instance.set_data(mod_data)
		var _error = instance.connect("mod_focused", self, "on_mod_focused")
		var _error_2 = instance.connect("mod_unfocused", self, "on_mod_unfocused")

		for author in mod_data.manifest.authors:
			if not authors_dictionary.has(author):
				authors_dictionary[author] = []
			authors_dictionary[author].append(instance)

		if mod_data.is_loadable:
			loaded_mod_count += 1
		else:
			error_mod_count += 1

	for author in authors_dictionary:
		var instance = mod_author_toggle.instance()
		instance.name = author
		instance.connect("author_toggled", self, "on_author_toggled")
		_author_container.add_child(instance)

	_mod_loaded_count_label.text = "Loaded: " + str(loaded_mod_count)
	_mod_disabled_count_label.text = "Disabled: " + str(error_mod_count)

func on_mod_focused(mod:ModData)->void:
	_mod_info_container.set_data(mod)


func on_mod_unfocused(_mod:ModData)->void:
	_mod_info_container.set_empty()


func on_author_toggled(author_check, state)->void:
	for author in authors_dictionary:
		if author == author_check:
			for mod in authors_dictionary[author]:
				mod.visible = state


func _on_BackButton_pressed()->void:
	emit_signal("back_button_pressed")


func _on_WorkshopButton_pressed()->void:
	Steam.activateGameOverlayToWebPage("https://steamcommunity.com/app/1942280/workshop/")
