extends Node2D

signal update_stats

export var slots: int
export (Array, PackedScene) var  default_itens_list 

var item_list : Array

func _ready():
	self.connect("update_stats",get_parent(), "_on_Status_changed")


func add_item(item):
	if item_list.size() < slots  && item_list.count(item) == 0:
		item.get_parent().remove_child(item);
		item_list.append(item)
		self.add_child(item)
		emit_signal("update_stats", item)
		
	
func remove_item(item):
	pass
