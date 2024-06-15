extends Node

signal attach_item
signal level_complete
signal switch_level

var is_dragging := false
var current_scene : String = "res://Levels/level_01.tscn"
var list_itens_avaiable: Array[String] = []
