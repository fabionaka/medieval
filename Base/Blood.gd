extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (bool) var one_shot
export (int) var layer1_velocity = 5
export (int) var layer2_velocity = 10
export (int) var layer3_velocity = 5
export (int) var velocity_dampening = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	var pYrng = RandomNumberGenerator.new()
	pYrng.randomize()
	position.y = pYrng.randf_range(-10, 0)
	
	var pXrng = RandomNumberGenerator.new()
	pXrng.randomize()
	position.x = pXrng.randf_range(-5, 5)
	
	if one_shot:
		$Particles2D.one_shot = one_shot
		$Particles2D/Particles2D.one_shot = one_shot;
		$Particles2D/Particles2D2.one_shot = one_shot;
		
	$Particles2D.emitting = true;
	$Particles2D/Particles2D.emitting = true;
	$Particles2D/Particles2D2.emitting = true;
	

	$Particles2D.process_material.initial_velocity = layer3_velocity * (get_parent().velocity.x / velocity_dampening * -1)
	$Particles2D/Particles2D.process_material.initial_velocity = layer2_velocity * (get_parent().velocity.x / velocity_dampening * -1)
	$Particles2D/Particles2D2.process_material.initial_velocity = layer1_velocity * (get_parent().velocity.x / velocity_dampening * -1)


func _process(delta):
	if !$Particles2D.emitting && !$Particles2D/Particles2D.emitting && !$Particles2D/Particles2D2.emitting:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
