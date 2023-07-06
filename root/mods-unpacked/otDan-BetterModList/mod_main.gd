extends Node


const MOD_NAME = "otDan-BetterModList"


var dir = ""
var translations_dir = ""
var extensions_dir = ""


func _init(_mod_loader):
	ModLoaderUtils.log_info("Init", MOD_NAME)

	dir = ModLoaderMod.get_unpacked_dir() + MOD_NAME + "/"
	translations_dir = dir + "translations/"
	extensions_dir = dir + "extensions/"

	_install_translations()
	_install_script_extensions()
	_add_child_classes()


func _ready():
	ModLoaderUtils.log_success("Loaded", MOD_NAME)


func _install_translations() -> void:
	ModLoaderMod.add_translation(translations_dir + "bettermodlist-translation.en.translation") # English
	ModLoaderMod.add_translation(translations_dir + "bettermodlist-translation.it_IT.translation") # Italian
	ModLoaderMod.add_translation(translations_dir + "bettermodlist-translation.pl_PL.translation") # Polish


func _install_script_extensions():
	ModLoaderMod.install_script_extension(extensions_dir + "ui/menus/title_screen/title_screen_menus.gd")


func _add_child_classes():
	var Colors = load(dir + "global/colors.gd").new()
	Colors.name = "Colors"
	add_child(Colors)
