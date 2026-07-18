class_name Emotions
extends Resource

const Emotion: Dictionary[String, Vector3] = {
	# Center
	"NEUTRALITY": Vector3(0, 0, 0),
	# Faces
	"DOMINANCE": Vector3(0, 0, 1),
	"LETHARGY": Vector3(0, -1, 0),
	"ALERTNESS": Vector3(0, 1, 0),
	"SADNESS": Vector3(-1, 0, 0),
	"HAPPINESS": Vector3(1, 0, 0),
	# Corners
	"DEPRESSION": Vector3(-1, -1, -1),
	"RELAXATION": Vector3(1, -1, -1),
	"ANXIETY": Vector3(-1, 1, -1),
	"CONTEMPT": Vector3(-1, -1, 1),
	"ADMIRATION": Vector3(1, 1, -1),
	"CONFIDENCE": Vector3(1, -1, 1),
	"ANGER": Vector3(-1, 1, 1),
	"EXCITEMENT": Vector3(1, 1, 1),
	# Edges
	"BOREDOM": Vector3(0, -1, -1),
	"TENSION": Vector3(0, 1, -1),
	"COMPOSURE": Vector3(0, -1, 1),
	"EXUBERANCE": Vector3(0, 1, 1),
	"FEAR": Vector3(-1, 0, -1),
	"COMPLIANCE": Vector3(1, 0, -1),
	"DISGUST": Vector3(-1, 0, 1),
	"DETERMINATION": Vector3(1, 0, 1),
	"DESPAIR": Vector3(-1, -1, 0),
	"CALMNESSNESS": Vector3(1, -1, 0),
	"PANIC": Vector3(-1, 1, 0),
	"JOY": Vector3(1, 1, 0),
}
const Difficulty: Dictionary[String, float] = {
	"STRICT": 0.05,
	"FAIR": 0.1,
	"LENIENT": 0.2,
	"CAREFREE": 0.4,
}


func close_to_emotion(input_vec: Vector3, expected: StringName, difficulty: float) -> bool:
	var expected_vec: Vector3 = Emotions[expected]
	var valid_x: bool = abs(input_vec.x - expected_vec.x) < difficulty
	var valid_y: bool = abs(input_vec.y - expected_vec.y) < difficulty
	var valid_z: bool = abs(input_vec.z - expected_vec.z) < difficulty
	return valid_x && valid_y && valid_z
