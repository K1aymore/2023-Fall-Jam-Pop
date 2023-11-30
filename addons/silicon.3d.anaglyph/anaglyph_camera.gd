extends Camera3D
class_name AnaglyphCamera

# How far apart the "eyes" are. A larger value makes a stronger anaglyph effect.
var separation := 0.02
# The distance at which rendered object appear normal. 
var convergence := 100.0
# How black and white the image should be.
var greyscale := 0.0
# Whether the scene should be rendered at half vertical resolution.
var half_res := 0.0

var _anaglyph: Node3D
var _viewport: Viewport


func _enter_tree() -> void:
	_anaglyph = preload("anaglyph_setup.tscn").instantiate()
	var material_inst: ShaderMaterial = \
			_anaglyph_node("Composite").material.duplicate()
	_anaglyph_node("Composite").material = material_inst
	add_child(_anaglyph)

func _ready():
	set_process_internal(true)
	_viewport = get_viewport()

func _process(delta: float) -> void:
	for camera in [_anaglyph_node("Left/Camera"), _anaglyph_node("Right/Camera")]:
		_update_camera_properties(camera)
	
	var is_current : bool = _viewport.get_camera_3d() == self
	_anaglyph_node("Composite").visible = is_current
	RenderingServer.viewport_set_disable_3d(_viewport.get_viewport_rid(), is_current)
	_update_camera_viewport_properties(_anaglyph_node("Left"), is_current)
	_update_camera_viewport_properties(_anaglyph_node("Right"), is_current)



func set_separation(value: float) -> void:
	separation = value


func set_convergence(value: float) -> void:
	convergence = max(value, 0.01)


func set_greyscale(value: float) -> void:
	if not _anaglyph:
		await ready
	
	greyscale = clamp(value, 0.0, 1.0)
	_anaglyph_node("Composite").material.set_shader_param(
		"black_and_white", greyscale
	)


func set_half_res(value: float) -> void:
	if not _anaglyph:
		await ready
	
	half_res = clamp(value, 0.0, 1.0)
	_anaglyph_node("Composite").material.set_shader_param(
		"half_res", half_res
	)


func _update_camera_viewport_properties(view: Viewport, is_current: bool) -> void:
	view.size = Vector2(_viewport.size) * Vector2.ONE.lerp(Vector2(1.0, 0.5), half_res);
#	view.msaa = _viewport.msaa
#	view.hdr = _viewport.hdr
	view.disable_3d = _viewport.disable_3d
#	view.keep_3d_linear = _viewport.keep_3d_linear
#	view.usage = _viewport.usage
	view.debug_draw = _viewport.debug_draw
	view.transparent_bg = _viewport.transparent_bg
#	view.render_target_v_flip = _viewport.render_target_v_flip
#	view.render_target_clear_mode = _viewport.render_target_clear_mode
#	view.render_target_update_mode = _viewport.render_target_update_mode
#	view.shadow_atlas_size = _viewport.shadow_atlas_size
#	view.shadow_atlas_quad_0 = _viewport.shadow_atlas_quad_0
#	view.shadow_atlas_quad_1 = _viewport.shadow_atlas_quad_1
#	view.shadow_atlas_quad_2 = _viewport.shadow_atlas_quad_2
#	view.shadow_atlas_quad_3 = _viewport.shadow_atlas_quad_3
	
	_update_camera_properties(view.get_camera_3d())


func _update_camera_properties(camera: Camera3D) -> void:
	var side := 1 if camera == _anaglyph_node("Right/Camera") else -1
	
	camera.far = far
	camera.near = near
	var cam_size: float = tan(deg_to_rad(fov) * 0.5) * near * 2.0
	# The near plane will have to enlargen to comenspate for the small camera size
	if cam_size < 0.1:
		camera.near = camera.near / cam_size * 0.1
		cam_size = 0.1
	camera.size = cam_size
	camera.frustum_offset = Vector2(separation / (camera.size / camera.near * convergence) * camera.near, 0) * -side
	camera.h_offset = h_offset
	camera.v_offset = v_offset
	camera.environment = environment
	camera.cull_mask = cull_mask
	
	camera.global_position = get_parent().global_position
	camera.global_rotation = _viewport.get_camera_3d().global_rotation
	camera.translate_object_local(Vector3.RIGHT * separation * side)


func _anaglyph_node(path: NodePath) -> Node:
	return _anaglyph.get_node(path)
