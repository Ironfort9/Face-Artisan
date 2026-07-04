extends Node3D

@export var canvas_size : Vector2i = Vector2i(1024, 1024)
@export var draw_size : Vector2 = Vector2(10.0, 10.0)
@export var draw_material : Material
@export var draw_albedo_texture : Texture2D
@export var base_mask : CompressedTexture2D
@export_color_no_alpha var base_mask_color : Color = Color.SADDLE_BROWN

@onready var canvas_mesh : MeshInstance3D = $Canvas/MeshInstance3D
@onready var camera : Camera3D = $Camera3D

var new_mask_path : String = "res://masks/curr_mask.res"
var base_mask_path : String = "res://masks/base_mask.res"

var color : Color;
var albedo_texture : DrawableTexture2D

var faces : PackedVector3Array = PackedVector3Array()
var uvs : PackedVector2Array = PackedVector2Array()
var triangle_mesh : TriangleMesh = TriangleMesh.new()

func _ready() -> void:	
	# Setup material
	var material : ORMMaterial3D = canvas_mesh.material_override
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var drawable_texture : DrawableTexture2D = DrawableTexture2D.new()
	drawable_texture.setup(canvas_size.x, canvas_size.y, DrawableTexture2D.DRAWABLE_FORMAT_RGBA8_SRGB, Color.TRANSPARENT)
	drawable_texture.blit_rect(Rect2i(Vector2i(0, 0), canvas_size), base_mask, base_mask_color)
	ResourceSaver.save(drawable_texture, base_mask_path)
	material.albedo_texture = drawable_texture
	albedo_texture = material.albedo_texture

	 
	# Setup mesh data
	var surface : Array = canvas_mesh.mesh.surface_get_arrays(0)
	var vertices : PackedVector3Array = surface[Mesh.ARRAY_VERTEX]
	var tex_uvs : PackedVector2Array = surface[Mesh.ARRAY_TEX_UV]
	var indices : PackedInt32Array = surface[Mesh.ARRAY_INDEX]
	var index_count : int = indices.size()
	uvs.resize(index_count)
	faces.resize(index_count)
	for index in range(index_count) :
		var vertex_idx : int = indices[index]
		uvs[index] = tex_uvs[vertex_idx]
		faces[index] = vertices[vertex_idx]
	triangle_mesh.create_from_faces(faces)
	# Setup draw material
	if draw_material:
		draw_material.set_shader_parameter("texture_size", canvas_size)


func _physics_process(_delta : float) -> void:
	pass


func _unhandled_input(event : InputEvent) -> void :
	if not draw_material :
		return
	if not color:
		return
	if event is InputEventMouseMotion or event is InputEventMouseButton :
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT :
			var uv = calculate_uv(event)
			if not uv.is_zero_approx() :
				var rect : Rect2 = Rect2(uv * Vector2(canvas_size) - draw_size * 0.5, draw_size)
				albedo_texture.blit_rect(rect, draw_albedo_texture, Color(color), 0, draw_material)


func calculate_uv(event : InputEvent) -> Vector2:
	var ray_origin : Vector3 = camera.project_ray_origin(event.position)
	var ray_normal : Vector3 = camera.project_ray_normal(event.position)
	var inv_transform : Transform3D = canvas_mesh.global_transform.inverse()
	ray_origin = inv_transform * ray_origin
	ray_normal = inv_transform.basis * ray_normal
	
	var intersect : Dictionary = triangle_mesh.intersect_ray(ray_origin, ray_normal)
	if not intersect.is_empty():
		var index : int = intersect.face_index * 3
		var f : Vector3 = intersect.position
		var p1 : Vector3 = faces[index]
		var p2 : Vector3 = faces[index + 1]
		var p3 : Vector3 = faces[index + 2]
		
		# Calculate vectors from point f to vertices p1, p2 and p3
		var f1 : Vector3 = p1 - f
		var f2 : Vector3 = p2 - f
		var f3 : Vector3 = p3 - f
		
		# Calculate the areas and factors
		var area : float = (p1 - p2).cross(p1 - p3).length()
		var a1 : float = f2.cross(f3).length() / area
		var a2 : float = f3.cross(f1).length() / area
		var a3 : float = f1.cross(f2).length() / area
		
		# Find the uv corresponding to point f
		var uv : Vector2 = uvs[index] * a1 + uvs[index + 1] * a2 + uvs[index + 2] * a3
		return uv
	else:
		return Vector2()


func _on_button_pressed() -> void:
	DirAccess.remove_absolute(new_mask_path)
	var image : Image = albedo_texture.get_image()
	var image_texture : ImageTexture = ImageTexture.new()
	image_texture.set_image(image)
	print(ResourceSaver.save(image_texture, new_mask_path))


func _on_red_button_pressed() -> void:
	color = Color.RED


func _on_green_button_pressed() -> void:
	color = Color.GREEN


func _on_blue_button_pressed() -> void:
	color = Color.BLUE
	
	
func _on_button_2_pressed() -> void:
	print(get_tree().change_scene_to_file("res://shop.tscn"))
