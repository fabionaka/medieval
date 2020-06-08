extends Node2D

export (int) var enemy_count
export (float) var spawn_delay
export (PackedScene) var enemy
export (bool) var active = true
export (bool) var chase_player = false


var enemies = 0;

func _ready():
	if active :
		for i in enemy_count:
			## ENEMY
			var e = enemy.instance()
			var rngX = RandomNumberGenerator.new()
			var rngY = RandomNumberGenerator.new()
			rngX.randomize()
			rngY.randomize()
			e.position = self.position + Vector2(rngX.randf_range(10,20), rngY.randf_range(10,20))
			if chase_player:
				e.target = get_parent().get_node("Player")
			get_parent().add_child(e)
			
			var t = Timer.new()
			t.set_wait_time(spawn_delay)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			enemies +=1
		
		if enemies > enemy_count:
			self.queue_free()
