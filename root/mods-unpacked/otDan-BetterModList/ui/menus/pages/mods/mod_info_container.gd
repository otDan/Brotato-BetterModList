class_name CustomModInfoContainer
extends PanelContainer

onready var _mod_name = $"%ModName" as Label
onready var _mod_author = $"%ModAuthor" as Label
onready var _mod_version = $"%ModVersion" as Label
onready var _mod_description = $"%ModDescription" as RichTextLabel
onready var _mod_dependency_container = $"%DependecyContainer" as VBoxContainer
onready var _mod_dependencies = $"%ModDependencies" as RichTextLabel

onready var Colors = get_node("/root/ModLoader/otDan-BetterModList/Colors")

func _ready()->void:
	set_empty()


func set_data(mod:ModData)->void:
	_mod_name.text = mod.manifest.name
	_mod_author.text = str(mod.manifest.authors)
	_mod_version.text = mod.manifest.version_number
	_mod_description.bbcode_text = mod.manifest.description
	if not PoolStringArray(mod.manifest.dependencies).empty():
		var dependencies: PoolStringArray
		for dependency in mod.manifest.dependencies:
			var string_dependency: String
			if ModLoader.mod_data.has(dependency):
				string_dependency += "[color=" + Colors.loaded + "]"
				string_dependency += str(dependency)
				string_dependency += "[/color]"
			else:
				string_dependency += "[color=" + Colors.unloaded + "]"
				string_dependency += str(dependency)
				string_dependency += "[/color]"
			dependencies.append(string_dependency)
		_mod_dependencies.bbcode_text = str(dependencies)
		_mod_dependency_container.visible = true
	else:
		_mod_dependency_container.visible = false

func set_empty()->void:
	_mod_name.text = ""
	_mod_author.text = ""
	_mod_version.text = ""
	_mod_description.bbcode_text = ""
	_mod_dependencies.text = ""
	_mod_dependency_container.visible = false
