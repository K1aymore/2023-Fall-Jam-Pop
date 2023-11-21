extends Node3D

func _ready() -> void:
	setOrtho()


func setPerspective():
	get_tree().call_group("Ortho", "hide")
	get_tree().call_group("Perspective", "show")


func setOrtho():
	get_tree().call_group("Perspective", "hide")
	get_tree().call_group("Ortho", "show")
