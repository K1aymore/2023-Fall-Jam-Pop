extends CharacterBody3D
class_name Player

enum {
	PERSPECTIVE,
	ORTHO,
	SWITCHPERSP,
	SWITCHORTHO
}

var state := ORTHO


const SPEED = 4.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	setState(ORTHO)


func _process(delta: float) -> void:
	if state == SWITCHORTHO:
		rotation.y = lerp(rotation.y, snapped(rotation.y, PI/2), delta * 10)
		$PerspectiveCam.rotation.x = lerp($PerspectiveCam.rotation.x, 0.0, delta * 10)
		if is_equal_approx(rotation.y, snapped(rotation.y, PI/2)):
			setState(ORTHO)
	
	if state == ORTHO:
		%OrthoCam.global_position = global_position
		%OrthoCam.global_rotation = global_rotation
	
	if Input.is_action_just_pressed("test"):
		pass
	if Input.is_action_just_pressed("test2"):
		pass



func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("switch"):
		switchModes()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	
	if state == ORTHO || state == SWITCHORTHO:
		input_dir.y = 0
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()




func setState(mode):
	match mode:
		PERSPECTIVE:
			$PerspectiveCam.current = true
			$ClickerOrthoCam.current = false
			%OrthoCam.current = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_parent().setPerspective()
			state = PERSPECTIVE
		ORTHO:
			$PerspectiveCam.current = false
			$ClickerOrthoCam.current = true
			%OrthoCam.current = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_parent().setOrtho()
			state = ORTHO



func switchModes():
	if state == PERSPECTIVE:
		state = SWITCHORTHO
	elif state == ORTHO:
		setState(PERSPECTIVE)



func _unhandled_input(event: InputEvent) -> void:
	if state == PERSPECTIVE && event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		rotate_y(-event.relative.x * 0.004)
		$PerspectiveCam.rotate_x(-event.relative.y * 0.004)
		get_viewport().set_input_as_handled()
		

