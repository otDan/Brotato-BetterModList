class_name CustomMenuMods
extends Control

signal back_button_pressed

export (PackedScene) var mod_container_scene
export (PackedScene) var mod_author_toggle

var authors_dictionary: Dictionary

onready var _author_container = $"%AuthorContainer"
onready var _mod_list_container = $"%ModListContainer"
onready var _mod_info_container = $"%ModInfoContainer"
onready var _mod_loaded_count_label = $"%LoadedModCount"
onready var _mod_disabled_count_label = $"%DisabledModCount"
onready var _workshop_button = $"%WorkshopButton"
onready var _back_button = $"%BackButton"


func init():
	_back_button.grab_focus()
	pass


func _ready() -> void:
	for n in _mod_list_container.get_children():
		_mod_list_container.remove_child(n)
		n.queue_free()

	var loaded_mod_count = 0
	var error_mod_count = 0

	var first_mod: Button = null
	var last_mod: Button = null
	for mod in ModLoader.mod_data:
		var instance: PanelContainer = mod_container_scene.instance()
		_mod_list_container.add_child(instance)
		var mod_data = ModLoader.mod_data[mod]
		instance.name = mod_data.manifest.name
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

		var mod_name_button: Button = instance.get_node("%ModNameButton")
		mod_name_button.focus_neighbour_right = _back_button.get_path()
		if not last_mod == null:
			last_mod.focus_neighbour_bottom = mod_name_button.get_path()
			mod_name_button.focus_neighbour_top = last_mod.get_path()
		if first_mod == null:
			first_mod = mod_name_button
		last_mod = mod_name_button
	last_mod.focus_neighbour_bottom = first_mod.get_path()
	first_mod.focus_neighbour_top = last_mod.get_path()
	sort_nodes(_mod_list_container, "sort")

	_back_button.focus_neighbour_left = _mod_info_container.get_child(0).get_path()
	_workshop_button.focus_neighbour_left = _mod_info_container.get_child(0).get_path()

	add_authors()

	_mod_loaded_count_label.text = "Loaded: " + str(loaded_mod_count)
	_mod_disabled_count_label.text = "Disabled: " + str(error_mod_count)


func add_authors():
	var first_author: CheckBox = null
	var last_author: CheckBox = null
	for author in authors_dictionary:
		var instance: CheckBox = mod_author_toggle.instance()
		instance.name = author
		var _author_toggled = instance.connect("author_toggled", self, "on_author_toggled")
		_author_container.add_child(instance)

		instance.focus_neighbour_left = _back_button.get_path()
		if not last_author == null:
			last_author.focus_neighbour_bottom = instance.get_path()
			instance.focus_neighbour_top = last_author.get_path()
		if first_author == null:
			first_author = instance
		last_author = instance
	last_author.focus_neighbour_bottom = first_author.get_path()
	first_author.focus_neighbour_top = last_author.get_path()
	_back_button.focus_neighbour_right = first_author.get_path()
	_workshop_button.focus_neighbour_right = first_author.get_path()


func sort_nodes(node: Node, sort_type: String):
	var sorter = load("res://mods-unpacked/otDan-BetterModList/global/node_sorter.gd").new()
	var children = node.get_children()

	children.sort_custom(sorter, sort_type)

	for child in children:
		node.remove_child(child)
		node.add_child(child)


func on_mod_focused(mod: ModData) -> void:
	_mod_info_container.set_data(mod)


func on_mod_unfocused(_mod: ModData) -> void:
	_mod_info_container.set_empty()


func on_author_toggled(author_check, state) -> void:
	for author in authors_dictionary:
		if author == author_check:
			for mod in authors_dictionary[author]:
				mod.visible = state


func _on_BackButton_pressed() -> void:
	emit_signal("back_button_pressed")


func _on_WorkshopButton_pressed() -> void:
	if ClassDB.class_exists("Steam"):
		var steam = ClassDB.instance("Steam")
		steam.activateGameOverlayToWebPage("https://steamcommunity.com/app/1942280/workshop/")
