extends Node3D

@export var mask_mesh : MeshInstance3D

@onready var label : Label = $Control/Label

func _ready() -> void:
	var curr_mask : ImageTexture = ResourceLoader.load("res://masks/curr_mask.res", "ImageTexture")
	var base_mask : Image = load("res://masks/base_mask.png")
	var curr_mask_size : Vector2i = curr_mask.get_size()
	base_mask.resize(curr_mask_size.x, curr_mask_size.y)
	_set_mask_info(curr_mask, base_mask)


func _set_mask_info(mask_texture: ImageTexture, base_mask_image: Image) -> void:
	var rgb : Vector3 = Vector3(0, 0, 0)
	var mask_image : Image = mask_texture.get_image()
	var size : Vector2i = mask_image.get_size()
	for x in range(size.x):
		for y in range(size.y):
			var pixel_color : Color = mask_image.get_pixel(x, y)
			var base_pixel_color : Color = base_mask_image.get_pixel(x, y)
			if pixel_color.is_equal_approx(base_pixel_color):
				print("({2}, {3}) => {0} == {1}".format([str(pixel_color), str(base_pixel_color), x, y]))
				continue
			if pixel_color.r > 0.8:
				rgb.x += 1
			if pixel_color.g > 0.8:
				rgb.y += 1
			if pixel_color.b > 0.8:
				rgb.z += 1
	var size_total : int = size.x * size.y
	label.text = "
	Total: {3}
	Red: {0}
	Green: {1}
	Blue: {2}
	%Red: {4}
	%Green: {5}
	%Blue: {6}
	".format([rgb.x, rgb.y, rgb.z, 
	size_total, 
	rgb.x / size_total * 100, 
	rgb.y / size_total * 100, 
	rgb.z / size_total * 100])
