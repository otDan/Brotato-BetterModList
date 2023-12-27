class_name CustomModInfoContainer
extends PanelContainer

onready var ListData = get_node("/root/ModLoader/otDan-BetterModList/ListData")
onready var Colors = get_node("/root/ModLoader/otDan-BetterModList/Colors")

onready var _mod_name = $"%ModName" as Label
onready var _mod_author = $"%ModAuthor" as Label
onready var _mod_website = $"%ModWebsite" as RichTextLabel
onready var _mod_version = $"%ModVersion" as Label
onready var _mod_description = $"%ModDescription" as RichTextLabel
onready var _mod_dependency_container = $"%DependecyContainer" as VBoxContainer
onready var _mod_dependencies = $"%ModDependencies" as RichTextLabel

var mod: ModData
var mod_style


func _ready() -> void:
	set_empty()

	var style = get_stylebox("panel")
	mod_style = style.duplicate()
	add_stylebox_override("panel", mod_style)


func set_data(passed_mod: ModData) -> void:
	mod = passed_mod
	_mod_name.text = mod.manifest.name
	_mod_author.text = str(mod.manifest.authors)
	var url = mod.manifest.website_url
	_mod_website.visible = url != ""
	url = url.replace("https://", "")
	_mod_website.bbcode_text = "[color=" + Colors.interactive + "][url]" + url + "[/url][/color]"
	_mod_version.text = "v" + mod.manifest.version_number
	_mod_description.bbcode_text = mod.manifest.description

	var missing_dependency: bool = false
	if not PoolStringArray(mod.manifest.dependencies).empty():
		var dependencies: PoolStringArray = []

		for dependency in mod.manifest.dependencies:
			var string_dependency: String = "[color=" + ListData.get_color(dependency) + "]"
			string_dependency += str(dependency)
			string_dependency += "[/color]"

			dependencies.append(string_dependency)

		_mod_dependencies.bbcode_text = str(dependencies)
		_mod_dependency_container.visible = true
	else:
		_mod_dependency_container.visible = false

	mod_style.bg_color = ListData.get_color(passed_mod.manifest.get_mod_id())


func set_empty() -> void:
	_mod_name.text = ""
	_mod_author.text = ""
	_mod_website.bbcode_text = ""
	_mod_version.text = ""
	_mod_description.bbcode_text = ""
	_mod_dependencies.text = ""
	_mod_dependency_container.visible = false


func _on_ModWebsite_meta_clicked(meta: String):
	var _output = OS.shell_open(str("https://", meta))
