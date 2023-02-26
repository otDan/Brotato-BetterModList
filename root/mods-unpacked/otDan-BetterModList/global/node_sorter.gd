class_name NodeSorter
extends Node

func sort(a, b):
	return a.name < b.name

func reverse_sort(a, b):
	return a.name > b.name
