extends KinematicBody2D

signal attack
signal health_changed
signal shield_changed

export (int) var max_acceleration
export (int) var max_speed
export (int) var friction
export (int) var health
export (float) var attack_range
export (float) var base_damage
export (float) var knockback
export (int) var attack_cooldown;

var animation
var acceleration
var velocity = Vector2.ZERO
var can_attack = null
var cooldown = 0
var hit_box_size
var sprite_size
var damage = 0
var block = 0
var damage_info = load("res://UI/DamageInfo.tscn")
var dead = false


onready var animationPlayer = $AnimationPlayer 
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	$DeathSprite.hide()
	$Sprite.show()
	
	#set hit_box size for player
	var hit_box = RectangleShape2D.new()
	sprite_size = Vector2($Sprite.get_rect().size)
	hit_box_size = Vector2(($Sprite.get_rect().size.x - 15), ($Sprite.get_rect().size.y - 20))
	$HitBox/HitBoxCollider.shape = hit_box
	$HitBox/HitBoxCollider.shape.set_extents(hit_box_size)
	
	# Init Attack Radius
	var attack_shape = CircleShape2D.new()
	attack_shape.radius = attack_range
	$AttackArea/AttackAreaCollider.shape = attack_shape
	
	# Connects the signals to the map
	self.connect("attack", get_tree().get_root().get_node('Map'), "_on_Entity_attack")
	
	# Calculate Attack Damage
	damage = base_damage


func control(delta):
	pass

func take_damage(damage) : 
	pass

func death():
	queue_free()

func _physics_process(delta):
	control(delta)
	velocity = move_and_slide(velocity)

func attack(damage):
	pass

func _on_HitBox_body_entered(body):
	pass

func calculate_damage(modifier = 0):
	damage += modifier
func calculate_block(modifier = 0):
	block += modifier
	emit_signal("shield_changed",block)
func calculate_health(modifier = 0):
	health += modifier
func calculate_speed(modifier = 0):
	max_speed += modifier
func calculate_attack_speed(modifier = 0):
	attack_cooldown += modifier

func _on_Status_changed(item):
	var index = 0
	for b in item.buffs :
		if b ==  item.BUFF_TYPE['ATTACK'] :
			calculate_damage(item.modifier[index])
		elif b ==  item.BUFF_TYPE['BLOCK'] :
			calculate_block(item.modifier[index])
		elif b ==  item.BUFF_TYPE['HEALTH'] :
			calculate_health(item.modifier[index])
		elif b ==  item.BUFF_TYPE['SPEED'] :
			calculate_speed(item.modifier[index])
		elif b ==  item.BUFF_TYPE['ATTACK_SPEED'] :
			calculate_attack_speed(item.modifier[index])
		index += 1;
	print(damage,"|", block,"|", health,"|", max_speed,"|", attack_cooldown)
