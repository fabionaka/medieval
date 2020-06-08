extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var played = false;

func _ready():
	pass

func _process(delta):
	yield($AnimationPlayer,"animation_finished")
	played = true
	if played :
		played = false
		queue_free()
	


func damage_display(damage):
	$Label.text = String(damage)
	$AnimationPlayer.play("PopUp")
	var x_pos =  ($Label.get_size().x*1.3) - get_parent().get_node("Sprite").get_rect().size.x
	var y_pos = get_parent().get_node("Sprite").get_rect().size.y - $Label.get_size().y
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	self.rect_position.x = (x_pos  + rng.randf_range(-5,5)) * -1
	self.rect_position.y = y_pos * -1
