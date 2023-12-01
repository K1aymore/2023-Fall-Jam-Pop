extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_quality_button_toggled(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")


func _on_quality_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		ProjectSettings.set_setting("rendering/lights_and_shadows/positional_shadow/soft_shadow_filter_quality", 5)
	else:
		ProjectSettings.set_setting("rendering/lights_and_shadows/positional_shadow/soft_shadow_filter_quality", 2)
	print(ProjectSettings.get_setting("rendering/lights_and_shadows/positional_shadow/soft_shadow_filter_quality"))
