extends Node

const MOD_NAME = "otDan-BetterModList"

var dir = ""

func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", MOD_NAME)

	modLoader.install_script_extension("res://mods-unpacked/otDan-BetterModList/extensions/ui/menus/title_screen/title_screen_menus.gd")
	modLoader.install_script_extension("res://mods-unpacked/otDan-BetterModList/extensions/ui/menus/pages/mods/mod_container.gd")

	dir = modLoader.UNPACKED_DIR + MOD_NAME + "/"
	modLoader.add_translation_from_resource(dir + "modlist_translation.en.translation")

func _ready():
	ModLoaderUtils.log_info("Readying", MOD_NAME)
	ModLoaderUtils.log_success("Loaded", MOD_NAME)
