class_name CustomMenuMods
extends Control

signal back_button_pressed

export (PackedScene) var mod_container_scene
export (PackedScene) var mod_author_toggle

var authors_dictionary: Dictionary

onready var author_panel = $"%AuthorPanel"
onready var author_container = author_panel.get_node("%ModContainer")
onready var mod_list_container = $"%ModListContainer"
onready var mod_info_container = $"%ModInfoContainer"
onready var mod_loaded_count_label = $"%LoadedModCount"
onready var mod_disabled_count_label = $"%DisabledModCount"
onready var _workshop_button = $"%WorkshopButton"
onready var _back_button = $"%BackButton"



func init():
	_back_button.grab_focus()
	pass


func _ready() -> void:
	for n in mod_list_container.get_children():
		mod_list_container.remove_child(n)
		n.queue_free()

	var loaded_mod_count = 0
	var error_mod_count = 0

	var first_mod: Button = null
	var last_mod: Button = null
	var mod_data_all = ModLoaderMod.get_mod_data_all()
	for mod in mod_data_all:
		var instance: PanelContainer = mod_container_scene.instance()
		mod_list_container.add_child(instance)
		var mod_data = mod_data_all[mod]
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
	sort_nodes(mod_list_container, "sort")

	_back_button.focus_neighbour_left = mod_info_container.get_child(0).get_path()
	_workshop_button.focus_neighbour_left = mod_info_container.get_child(0).get_path()

	add_authors()

	mod_loaded_count_label.text = "Loaded: " + str(loaded_mod_count)
	mod_disabled_count_label.text = "Disabled: " + str(error_mod_count)


func add_authors():
	var first_author: CheckBox = null
	var last_author: CheckBox = null
	for author in authors_dictionary:
		var instance: CheckBox = mod_author_toggle.instance()
		var _author_toggled = instance.connect("author_toggled", self, "on_author_toggled")
		author_container.add_child(instance)
		
		var mod_count = 0
		if authors_dictionary.has(author):
			mod_count = authors_dictionary[author].size()
		instance.set_info(author, mod_count)

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
	var NodeSorter = load("res://mods-unpacked/otDan-BetterModList/global/node_sorter.gd").new()
	var children = node.get_children()

	children.sort_custom(NodeSorter, sort_type)

	for child in children:
		node.remove_child(child)
		node.add_child(child)


func on_mod_focused(mod: ModData) -> void:
	mod_info_container.set_data(mod)


func on_mod_unfocused(_mod: ModData) -> void:
	mod_info_container.set_empty()


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
