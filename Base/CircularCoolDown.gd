extends Node2D

var slider = 0;

func _ready():
	self.visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if slider > 0:
		self.visible
	self.global_position = get_global_mouse_position() + Vector2(1, 1)
	if slider >= 100:
		queue_free()
	
func update_counter(value):
	slider = value
	$Panel.get_material().set_shader_param("value",value)

