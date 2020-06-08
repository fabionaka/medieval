extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Health_updated(health):
	if(health < 0):
		health = 0
	$VBoxContainer/HBoxContainer/Health.text = String(health) + '%'

func _on_Block_updated(block):
	$VBoxContainer/HBoxContainer/Shield.text = String(block) + '%'
