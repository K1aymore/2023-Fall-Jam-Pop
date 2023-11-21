extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for light in get_children():
		if light is Light3D:
			light.visible = false



func _on_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_action_pressed("drag"):
		for light in get_children():
			if light is Light3D:
				light.visible = !light.visible
