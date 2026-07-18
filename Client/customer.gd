class_name Customer
extends Node

@onready var client_body: CharacterBody3D = $ClientBody


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var client_mesh: Mesh = $ClientBody/MeshInstance3D.get_mesh()
	var client_material: StandardMaterial3D = StandardMaterial3D.new()
	client_material.albedo_color = Color(5.0 + randf() * 220.0, 5.0 + randf() * 220.0, 5.0 + randf() * 220.0)
	client_mesh.surface_set_material(0, client_material)


func _generate_customer_request() -> void:
	pass
