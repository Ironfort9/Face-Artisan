extends Node3D

@export var debug: bool = true
@export var mask_mesh: MeshInstance3D

var emotion_data: Vector3

@onready var label: Label = $Control/Label


func _ready() -> void:
	var curr_mask: ImageTexture = ResourceLoader.load("res://masks/curr_mask.res", "ImageTexture")
	var base_mask: Image = load("res://masks/base_mask.res")
	var curr_mask_size: Vector2i = curr_mask.get_size()
	base_mask.resize(curr_mask_size.x, curr_mask_size.y)
	_set_mask_info(curr_mask, base_mask)


func _set_mask_info(mask_texture: ImageTexture, base_mask_image: Image) -> void:
	var rgb: Vector3 = Vector3(0, 0, 0)
	var mask_image: Image = mask_texture.get_image()
	var size: Vector2i = mask_image.get_size()
	var size_total: int = size.x * size.y
	var file: FileAccess
	if debug:
		file = FileAccess.open("res://pixel_info.txt", FileAccess.WRITE)
	for x in range(size.x):
		for y in range(size.y):
			var pixel_color: Color = mask_image.get_pixel(x, y)
			var base_pixel_color: Color = base_mask_image.get_pixel(x, y)
			if debug:
				file.store_string(
					"({0}, {1}) => {2} || {3}\n"
					.format([x, y, pixel_color, base_pixel_color]),
				)
			if pixel_color.a < 1.0 or pixel_color == base_pixel_color:
				size_total -= 1
			if pixel_color.r > base_pixel_color.r:
				rgb.x += 1
			elif pixel_color.g > base_pixel_color.g:
				rgb.y += 1
			elif pixel_color.b > base_pixel_color.b:
				rgb.z += 1
	var prevalent_emotion: float = max(rgb.x, rgb.y, rgb.z, 1)
	emotion_data = Vector3(
		rgb.x / prevalent_emotion,
		rgb.y / prevalent_emotion,
		rgb.z / prevalent_emotion,
	)
	label.text = "Total: {3}
	Red: {0}
	Green: {1}
	Blue: {2}
	%Red: {4}%
	%Green: {5}%
	%Blue: {6}%
	".format(
		[
			rgb.x,
			rgb.y,
			rgb.z,
			size_total,
			"%3.3f" % (rgb.x / prevalent_emotion * 100),
			"%3.3f" % (rgb.y / prevalent_emotion * 100),
			"%3.3f" % (rgb.z / prevalent_emotion * 100),
		],
	)
