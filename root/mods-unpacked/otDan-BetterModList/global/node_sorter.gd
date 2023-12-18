class_name NodeSorter
extends Node


func sort(a, b):
	return a.name < b.name


func reverse_sort(a, b):
	return a.name > b.name


func sort_descending(version1: String, version2: String):
	var version1_parts = version1.split('.')
	var version2_parts = version2.split('.')

	for i in range(0, 4):
		if int(version1_parts[i]) > int(version2_parts[i]):
			return false
		elif int(version1_parts[i]) < int(version2_parts[i]):
			return true

	return false
