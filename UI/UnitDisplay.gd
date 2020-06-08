extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		node.hide()

	
func _process(delta):
	global_rotation = 0;


func update_healthbar(value):
	var cor = StyleBoxFlat.new()
	cor.set_bg_color(Color.green)
	if value > 0 :
		$Healthbar.show()
	
	if value < 80  :
		cor.set_bg_color(Color.yellowgreen)
	if value < 50  :
		cor.set_bg_color(Color.yellow)
	if value < 20 :
		cor.set_bg_color(Color.red)
	
	$Healthbar.set('custom_styles/fg', cor)
	$Healthbar/Tween.interpolate_property($Healthbar,
		"value", $Healthbar.value, value, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Healthbar/Tween.start()
