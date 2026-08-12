extends Node3D

@export var mask_mesh: MeshInstance3D

# Using the 'PAD emotional state model' for the data
# x = Non-Arousal => Arousal | Goes from 0 -> 1
# y = Displeasure => Pleasure | Goes from 0 -> 1
# z = Submissiveness => Dominance | Goes from 0 -> 1
# w = Neutrality (Lack of any color, used to achieve intermediate values without 
#                 another value being dominant)
var emotion_data: Vector3

@onready var label: Label = $Control/Label


func _ready() -> void:
	var curr_mask: ImageTexture = ResourceLoader.load("res://masks/curr_mask.res", "ImageTexture")
	var base_mask: Image = load("res://masks/base_mask.res")
	var curr_mask_size: Vector2i = curr_mask.get_size()
	base_mask.resize(curr_mask_size.x, curr_mask_size.y)
	_set_mask_info(curr_mask, base_mask)


func _set_mask_info(mask_texture: ImageTexture, base_mask_image: Image) -> void:
	var emotion_vector: Vector4 = Vector4.ZERO
	var mask_image: Image = mask_texture.get_image()
	var size: Vector2i = mask_image.get_size()
	var size_total: int = size.x * size.y
	var file: FileAccess
	if GlobalFlags.debug:
		file = FileAccess.open("res://pixel_info.txt", FileAccess.WRITE)
	for x in range(size.x):
		for y in range(size.y):
			var pixel_color: Color = mask_image.get_pixel(x, y)
			var base_pixel_color: Color = base_mask_image.get_pixel(x, y)
			if GlobalFlags.debug:
				file.store_string(
					"({0}, {1}) => {2} || {3}\n"
					.format([x, y, pixel_color, base_pixel_color]),
				)
			if pixel_color.a < 1.0:
				size_total -= 1
			elif pixel_color == base_pixel_color:
				emotion_vector.w += 1
			elif pixel_color.r > base_pixel_color.r:
				emotion_vector.x += 1
			elif pixel_color.g > base_pixel_color.g:
				emotion_vector.y += 1
			elif pixel_color.b > base_pixel_color.b:
				emotion_vector.z += 1
	var prevalent_emotion: float = max(
		emotion_vector.x, # Non-Arousal / Arousal
		emotion_vector.y, # Displeasure / Pleasure
		emotion_vector.z, # Submissiveness / Dominance
		emotion_vector.w, # Neutrality
	)
	emotion_data = Vector3(
		emotion_vector.x / prevalent_emotion,
		emotion_vector.y / prevalent_emotion,
		emotion_vector.z / prevalent_emotion,
	)
	label.text = "Total: {0}
	Red: {1}
	Green: {2}
	Blue: {3}
	Neutral: {4}
	%Red: {5}%
	%Green: {6}%
	%Blue: {7}%
	%Neutral: {8}%
	Emotion: {9}
	".format(
		[
			size_total,
			emotion_vector.x,
			emotion_vector.y,
			emotion_vector.z,
			emotion_vector.w,
			"%.3f" % (emotion_vector.x / prevalent_emotion * 100),
			"%.3f" % (emotion_vector.y / prevalent_emotion * 100),
			"%.3f" % (emotion_vector.z / prevalent_emotion * 100),
			"%.3f" % (emotion_vector.w / prevalent_emotion * 100),
			EmotionTools.closest_emotion(emotion_data),
		],
	)
