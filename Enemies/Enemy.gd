extends "res://Base/Character.gd"

signal enemy_death

export (int) var detectRadius
export (int) var coins
export (Array, PackedScene) var item_drop_list
export (Array) var item_drop_probability
export (PackedScene) var blood


var target = null
var target_timing = 0;
var enemy_stop_count = 0
var target_vector_auto = Vector2.ZERO

func _ready():
	add_to_group("enemies")
	
	var circle = CircleShape2D.new()
	$Detection/Collission.shape = circle
	$Detection/Collission.shape.radius = detectRadius
	
	# HealthBar
	$UnityDisplay/Healthbar.value = health 
	$UnityDisplay.scale = Vector2(sprite_size.x/$UnityDisplay/Healthbar.rect_size.x, sprite_size.x/$UnityDisplay/Healthbar.rect_size.x)
	$UnityDisplay.position = Vector2((sprite_size.x / 2) * -1, (sprite_size.y / 1.5) * -1)
	connect("enemy_death",get_tree().get_root().get_node('Map'),"_on_Enemy_death_drop")
	
	
func _process(delta):
	if can_attack && cooldown == 0:
		emit_signal("attack",target, base_damage)
		cooldown = attack_cooldown
	
	if can_attack && cooldown != 0:
		cooldown -= 1
		
func _physics_process(delta):
	if target :
		control(delta)

func control(delta):
	
	if dead: 
		velocity = Vector2.ZERO
		return
		
	var target_vector = Vector2.ZERO
	if target:
		$Sprite.set_self_modulate(Color(0.760784,0.301961,0.301961,1));
		target_vector = (target.global_position - global_position) * delta
		target_vector = target_vector.normalized()
		for o in $AttackArea.get_overlapping_bodies() :
			if target.name == o.name :
				target_vector = Vector2.ZERO
		velocity = velocity.move_toward(target_vector * max_speed, max_acceleration * delta)
	elif !target && target_timing < 50:
		$Sprite.set_self_modulate(Color(1,1,1,1))
		var rngx = RandomNumberGenerator.new()
		var rngy = RandomNumberGenerator.new()
		if target_timing == 0:
			rngx.randomize()
			rngy.randomize()
			target_vector_auto = Vector2(rngx.randf_range(-1,1), rngy.randf_range(-1,1)) /2 * delta
			target_vector_auto = target_vector_auto.normalized()
		target_vector = target_vector_auto
		velocity = velocity.move_toward(target_vector_auto * max_speed, max_acceleration * delta)
		target_timing += 1
	else :
		$Sprite.set_self_modulate(Color(1,1,1,1))
		velocity = velocity.move_toward(Vector2.ZERO, delta * friction)
		if enemy_stop_count == 100 :
			target_timing = 0
			enemy_stop_count = 0
			
		enemy_stop_count += 1
		
		
		
	animation_state(target_vector)

func animation_state(vector):
	if vector != Vector2.ZERO :
		animationTree.set("parameters/Idle/blend_position", vector)
		animationTree.set("parameters/Run/blend_position", vector)
		animationState.travel("Run")
	else :
		animationState.travel("Idle")

func take_damage(damage) : 
	if blood:
		var b = blood.instance()
		self.add_child(b)
	health -= damage
	$UnityDisplay.update_healthbar(health)
	
	## info display
	var dmg_info_taken = damage_info.instance()
	self.add_child(dmg_info_taken)
	dmg_info_taken.damage_display(damage)
	
	if health <= 0 :
		death()

func _on_Detection_body_entered(body):
	if body.name == 'Player':
		target = body


func _on_Detection_body_exited(body):
	if body.name == 'Player':
		target = null


func _on_AttackArea_body_entered(body):
	if body == target:
		can_attack = true


func _on_AttackArea_body_exited(body):
	if body == target:
		can_attack = false

func death():
	emit_signal("enemy_death", item_drop_list, self)
	target = null
	dead = true;
	$CollisionShape2D.queue_free()
	$UnityDisplay.hide()
	$AnimationPlayer.get_animation("Death")
	$AnimationPlayer.play("Death")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
