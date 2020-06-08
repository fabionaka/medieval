extends "res://Base/Character.gd"

enum {
	MOVE,ROLL,ATTACK,TAKE_DAMAGE, DEATH
}
signal attack_cooldown


var state = MOVE
var damage_taken = false

func _ready():
	can_attack = true
	cooldown = attack_cooldown
	var health_bar = get_tree().get_nodes_in_group("healthbar")
	if health_bar.size() > 0:
		self.connect("health_changed", health_bar[0], "_on_Health_updated")
		self.connect("shield_changed", health_bar[0], "_on_Block_updated")
		
	emit_signal("health_changed",health)
	emit_signal("shield_changed",block)
	add_to_group("player")
	$AttackSprite.hide()
	$DeathSprite.hide()
	

func _physics_process(delta):
	if cooldown < attack_cooldown :
		cooldown += 1
		emit_signal("attack_cooldown", cooldown * 100 / attack_cooldown)
	elif cooldown >= attack_cooldown :
		cooldown = attack_cooldown
		can_attack == true

func control(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			pass

	if dead  || damage_taken:
		velocity = Vector2.ZERO
		return



func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, max_acceleration * delta)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Damage/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
	else :
		velocity = velocity.move_toward(Vector2.ZERO, delta * friction)
		animationState.travel("Idle")

	if Input.is_action_just_pressed("attack") :
		state = ATTACK

func attack_state(delta):
	if cooldown == attack_cooldown && can_attack:
		can_attack = false
		# cooldown marker
		var cd_marker = load("res://Base/CircularCoolDown.tscn")
		var coolDownScene = cd_marker.instance();
		self.connect("attack_cooldown",coolDownScene,"update_counter")
		get_tree().get_root().get_children()[0].add_child(coolDownScene)
		emit_signal("attack_cooldown", 0)
		
		
		velocity = velocity / 2
		var input_vector = Vector2.ZERO
		animationState.travel("Attack")
		cooldown = 0

		for i in $AttackArea.get_overlapping_bodies():
			if i.get_collision_layer() == 2:
				emit_signal("attack",i, damage)
	
func attack_animation_ended():
	state = MOVE
	can_attack = true
	
func attack_animation_modifiers():
	$AttackSprite.look_at(get_global_mouse_position())


func take_damage(damage) :
	if block !=0:
		damage = damage * (1 - float(block)/float(100))
	health -= damage

	## info display
	var dmg_info_taken = damage_info.instance()
	self.add_child(dmg_info_taken)
	dmg_info_taken.damage_display(damage)
	
	emit_signal("health_changed",health)


	if health <= 0 :
		death()
	print("PlayerHealth: ",health);




func death():
	dead = true;
	$AnimationPlayer.play("Death")
	yield($AnimationPlayer,"animation_finished")
	queue_free()

