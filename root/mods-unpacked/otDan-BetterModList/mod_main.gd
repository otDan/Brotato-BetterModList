extends Node

const MOD_NAME = "otDan-BetterModList"

var dir = ""

func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", MOD_NAME)
	dir = modLoader.UNPACKED_DIR + MOD_NAME + "/"

	_add_child_classes()

	modLoader.install_script_extension(dir + "/extensions/ui/menus/title_screen/title_screen_menus.gd")

	modLoader.add_translation_from_resource(dir + "modlist_translation.en.translation")

func _ready():
	ModLoaderUtils.log_info("Readying", MOD_NAME)
	ModLoaderUtils.log_success("Loaded", MOD_NAME)

func _add_child_classes():
	var Colors = load(dir + "static/colors.gd").new()
	Colors.name = "Colors"
	add_child(Colors)
