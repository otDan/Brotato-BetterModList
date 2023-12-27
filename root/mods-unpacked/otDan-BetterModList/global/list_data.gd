extends Node
class_name ListData

onready var Colors = get_node("/root/ModLoader/otDan-BetterModList/Colors")

var mod_data_all

var mods: Dictionary
var loaded: int = 0
var warning: int = 0
var disabled: int = 0 

enum ModState {LOADED, WARNING, DISABLED}


func load_mods():
	mod_data_all = ModLoaderMod.get_mod_data_all()
	for mod_id in mod_data_all:
		add_mod(mod_id)
#		print("Mod added is ", mod, " cause ", mods)
	check()


func add_mod(mod_id: String, check: bool = false):
	if mod_id == null:
		print("Somehow mod is null ", mod_id)
		return
			
	if mods.has(mod_id):
		print("Mod was already added and is ", mod_id)
		return
	
	var additional_info: Dictionary
	additional_info[ModState] = ModState.LOADED
	mods[mod_id] = additional_info
	
	if check:
		check()


func check():
	loaded = 0
	warning = 0
	disabled = 0
	
	for mod_id in mods:
		var mod_data = ModLoaderMod.get_mod_data(mod_id)
			
#		if not PoolStringArray(mod_data.manifest.dependencies).empty():
#			for dependency in mod_data.manifest.dependencies:
#				if mod_data_all.has(dependency):
#					var dependency_mod = mod_data_all.get(dependency)
#					var highest_version = get_highest_version(dependency_mod.manifest.compatible_game_version)
##					print("Highest version ", highest_version)
#					if is_version_greater(ProgressData.VERSION, highest_version):
#						mods[mod_id][ModState] = ModState.WARNING
#						warning += 1
						
		if mod_data.is_loadable:
			loaded += 1
			
			var highest_version = get_highest_version(mod_data.manifest.compatible_game_version)
			if is_version_greater(ProgressData.VERSION, highest_version):
						mods[mod_id][ModState] = ModState.WARNING
						warning += 1
		else:
			mods[mod_id][ModState] = ModState.DISABLED
			disabled += 1


func get_highest_version(compatible_game_version: PoolStringArray):
	var game_versions: Array = compatible_game_version
	var NodeSorter = load("res://mods-unpacked/otDan-BetterModList/global/node_sorter.gd").new()
	game_versions.sort_custom(NodeSorter, "sort_descending")

	var highest_version = game_versions[0]
	return highest_version
	

func is_version_greater(version_1: String, version_2: String):
	var versions_1 = version_1.split('.')
	var versions_2 = version_2.split('.')

	for i in range(0, 4):
		if versions_1[i] > versions_2[i]:
			return true
		elif versions_1[i] < versions_2[i]:
			return false

	return false
	
	
func get_color(mod_id: String):
	if not mods.has(mod_id):
		print("Mod ", mod_id, " is not present in ListData")
		
	var mod_state = mods[mod_id][ModState]
	match mod_state:
		ModState.LOADED:
			return Colors.loaded
		ModState.WARNING:
			return Colors.warning
		ModState.DISABLED:
			return Colors.unloaded
			
	print("Mod ", mod_id, " has not matched ModState and is ", mod_state)
	
	return Colors.error
