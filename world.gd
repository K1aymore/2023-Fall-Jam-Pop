extends Node3D

func _ready() -> void:
	setOrtho()


func setPerspective():
	get_tree().call_group("Ortho", "hide")
	get_tree().call_group("Perspective", "show")
	
	for child in $Lights.get_children():
		for light in child.get_children():
			if light is Light3D:
				light.shadow_enabled = true
		
		if child is Light3D:
			child.shadow_enabled = true


func setOrtho():
	get_tree().call_group("Perspective", "hide")
	get_tree().call_group("Ortho", "show")
	
	for child in $Lights.get_children():
		for light in child.get_children():
			if light is Light3D:
				light.shadow_enabled = false
		
		if child is Light3D:
			child.shadow_enabled = false
