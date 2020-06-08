extends MarginContainer

func _ready():
	self.visible = false
func _process(delta):
	if get_tree().get_nodes_in_group("player").size() < 1 :
		self.visible = true


func _on_Button_pressed():
	get_tree().reload_current_scene()
