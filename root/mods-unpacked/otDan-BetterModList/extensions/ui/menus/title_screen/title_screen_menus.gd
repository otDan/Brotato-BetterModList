extends "res://ui/menus/title_screen/title_screen_menus.gd"

var _custom_menu_mods


func _ready():
	_custom_menu_mods = load("res://mods-unpacked/otDan-BetterModList/ui/menus/pages/mods/menu_mods.tscn").instance()
	add_child(_custom_menu_mods)
	_custom_menu_mods.visible = false
	_custom_menu_mods.connect("back_button_pressed", self, "_on_MenuMods_back_button_pressed")


func _on_MainMenu_mods_button_pressed() -> void:
	switch(_main_menu, _custom_menu_mods)


func _on_MenuMods_back_button_pressed() -> void:
	switch(_custom_menu_mods, _main_menu)
