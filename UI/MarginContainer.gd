extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	print(get_tree().get_nodes_in_group("enemies").size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  get_tree().get_nodes_in_group("enemies").size() < 1 :
		self.visible = true
	else :
		self.visible=false

func _on_Button_pressed():
	get_tree().reload_current_scene()
