extends Node2D

signal picked_equip

enum BUFF_TYPE {
	ATTACK,
	BLOCK,
	HEALTH,
	SPEED,
	ATTACK_SPEED
}

export (Array, BUFF_TYPE) var buffs
export (Array, int) var modifier
export (Texture) var icon
export (bool) var pickable
export (int, 0, 20) var pick_radius
export (int) var time_left
export (float) var drop_chance

var entity
var entity_time = 0;
var local_timer = false

func _ready():
	$Sprite.texture = icon
	self.connect("picked_equip", get_tree().get_root().get_node('Map'), "_on_Entity_pick_equipment")
	
	if pickable :
		var obj_shape = CircleShape2D.new()
		obj_shape.radius = pick_radius
		$PickArea/PickRadius.shape = obj_shape
	
	local_timer = true;

func _physics_process(delta):
	
	## Processa as colisões para ver se alguem entrou em  seu raio de pick
	if $PickArea.get_overlapping_bodies() : 
		if $PickArea.get_overlapping_bodies()[0] && entity != $PickArea.get_overlapping_bodies()[0]: 
			entity = $PickArea.get_overlapping_bodies()[0]
			emit_signal("picked_equip", $PickArea.get_overlapping_bodies()[0], self, self.get_parent())
	
	## esconde a entidade quando ela está em um inventário
	if visible && get_parent().name == 'Inventory' : 
		self.hide()
	elif get_parent().name != 'Inventory' && !visible : 
		self.show()
	
	## Timer para limpar a entidade do mapa quando não for apanhado
	if local_timer && get_parent().name != 'Inventory': 
		if time_left * delta <= entity_time * delta : 
			queue_free()
		entity_time += (1 * delta)
		
func play_drop_animation():
	$AnimationPlayer.play("PopUp")
