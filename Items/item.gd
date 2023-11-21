extends CharacterBody3D

var dragging := false


func _physics_process(delta: float) -> void:
	var result : KinematicCollision3D
	
	if !Input.is_action_pressed("drag") && dragging:
		dragging = false
		print("bye")
	
	
	
	if dragging:
		var player : Player = get_tree().get_first_node_in_group("Player")
		var playerRot : int = snapped(player.rotation_degrees.y, 90)
		
		var newPos := Vector3.ZERO
		var distToPlayer := (player.global_position - global_position).abs()
		
		
		newPos.y = player.global_position.y-(get_viewport().get_mouse_position().y / 350) + 1.5
		velocity.y = newPos.y - global_position.y
		
		if playerRot == 0:
			newPos.x = (get_viewport().get_mouse_position().x / 350) - 2.75
			velocity.x = newPos.x - global_position.x + player.global_position.x
		
		if playerRot == 90:
			newPos.z = -(get_viewport().get_mouse_position().x / 350) + 3
			velocity.z = newPos.z - global_position.z + player.global_position.z
		
		if playerRot == -90:
			newPos.z = (get_viewport().get_mouse_position().x / 350) - 3
			velocity.z = newPos.z - global_position.z + player.global_position.z
		
		if playerRot == -180:
			newPos.x = -(get_viewport().get_mouse_position().x / 350) + 3
			print(newPos.x)
			velocity.x = newPos.x - global_position.x + player.global_position.x
		
		
		velocity *= 5
		
	
	
	
	if !dragging:
		velocity.y -= delta * 3
		pass
	
	
	result = move_and_collide(velocity * delta)
	if result != null:
		if result.get_collider().has_method("collide"):
			result.get_collider().collide(self)
		
		if result.get_collider().name.contains("floor"):
			velocity = Vector3.ZERO





func _on_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton && Input.is_action_pressed("drag"):
		print("hey")
		dragging = true
