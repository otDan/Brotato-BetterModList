extends Node


const MOD_NAME = "otDan-BetterModList"


var mod_loader
var dir = ""
var translations_dir = ""
var extensions_dir = ""


func _init(mod_loader = ModLoader):
	ModLoaderUtils.log_info("Init", MOD_NAME)
	self.mod_loader = mod_loader

	dir = mod_loader.UNPACKED_DIR + MOD_NAME + "/"
	translations_dir = dir + "translations/"
	extensions_dir = dir + "extensions/"

	_install_translations()
	_install_script_extensions()
	_add_child_classes()


func _ready():
	ModLoaderUtils.log_success("Loaded", MOD_NAME)


func _install_translations()->void:
	mod_loader.add_translation_from_resource(translations_dir + "bettermodlist-translation.en.translation") # English
	mod_loader.add_translation_from_resource(translations_dir + "bettermodlist-translation.it_IT.translation") # Italian
	mod_loader.add_translation_from_resource(translations_dir + "bettermodlist-translation.pl_PL.translation") # Polish


func _install_script_extensions():
	mod_loader.install_script_extension(extensions_dir + "ui/menus/title_screen/title_screen_menus.gd")


func _add_child_classes():
	var Colors = load(dir + "global/colors.gd").new()
	Colors.name = "Colors"
	add_child(Colors)
