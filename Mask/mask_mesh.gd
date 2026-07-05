extends MeshInstance3D

var mask_mesh: MeshInstance3D = self


func _init() -> void:
	if ResourceLoader.exists("res://masks/curr_mask.res"):
		material_override = ORMMaterial3D.new()
		material_override.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material_override.albedo_texture = ResourceLoader.load("res://masks/curr_mask.res", "ImageTexture")


func _ready() -> void:
	pass
