extends Node2D


func _on_Entity_attack(target, damage):
	if target :
		target.take_damage(damage)
	
func _on_Entity_pick_equipment(target, equipment, parent_node):
	var target_inventory = target.get_node("Inventory")
	if target_inventory:
		target_inventory.add_item(equipment)

func _on_Enemy_death_drop(equip, parent):
	for e in equip:
		var eqp = e.instance()
		var prob = RandomNumberGenerator.new()
		prob.randomize()
		var probability = prob.randf_range(0, 1)
		if probability <= eqp.drop_chance :
			eqp.position = parent.position
			eqp.position.x = eqp.position.x + prob.randf_range(-5, 5)
			$MapCharacters.add_child(eqp)
			eqp.play_drop_animation()
		else :
			eqp.queue_free()
