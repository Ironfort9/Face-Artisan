class_name EmotionTools
extends Node

## x = Non-Arousal => Arousal | Goes from 0 -> 1 [br]
## y = Displeasure => Pleasure | Goes from 0 -> 1 [br]
## z = Submissiveness => Dominance | Goes from 0 -> 1 [br]
## w = Neutrality (Lack of any color, used to achieve intermediate values without 
##                 another value being dominant)
const Emotion: Dictionary[StringName, Vector3] = {
	# Center
	"NEUTRALITY": Vector3(0, 0, 0),
	# Faces
	"DOMINANCE": Vector3(0.5, 0.5, 1),
	"LETHARGY": Vector3(0.5, 0, 0.5),
	"ALERTNESS": Vector3(0.5, 1, 0.5),
	"SADNESS": Vector3(0, 0.5, 0.5),
	"HAPPINESS": Vector3(1, 0.5, 0.5),
	# Corners
	"DEPRESSION": Vector3(0, 0, 0),
	"RELAXATION": Vector3(1, 0, 0),
	"ANXIETY": Vector3(0, 1, 0),
	"CONTEMPT": Vector3(0, 0, 1),
	"ADMIRATION": Vector3(1, 1, 0),
	"CONFIDENCE": Vector3(1, 0, 1),
	"ANGER": Vector3(0, 1, 1),
	"EXCITEMENT": Vector3(1, 1, 1),
	# Edges
	"BOREDOM": Vector3(0.5, 0, 0),
	"TENSION": Vector3(0.5, 1, 0),
	"COMPOSURE": Vector3(0.5, 0, 1),
	"EXUBERANCE": Vector3(0.5, 1, 1),
	"FEAR": Vector3(0, 0.5, 0),
	"COMPLIANCE": Vector3(1, 0.5, 0),
	"DISGUST": Vector3(0, 0.5, 1),
	"DETERMINATION": Vector3(1, 0.5, 1),
	"DESPAIR": Vector3(0, 0, 0.5),
	"CALMNESSNESS": Vector3(1, 0, 0.5),
	"PANIC": Vector3(0, 1, 0.5),
	"JOY": Vector3(1, 1, 0.5),
}
const Difficulty: Dictionary[StringName, float] = {
	"STRICT": 0.05,
	"FAIR": 0.1,
	"LENIENT": 0.2,
	"CAREFREE": 0.4,
}


static func closest_emotion(_input_vec: Vector3) -> StringName:
	var emotion_names: Array[StringName] = Emotion.keys()
	var _closest_emotion: StringName = emotion_names[0]
	var closest_distance: float = INF
	for emotion_name in emotion_names:
		var current_distance: float = Emotion[emotion_name].distance_to(_input_vec)
		if current_distance < closest_distance:
			_closest_emotion = emotion_name
			closest_distance = current_distance
	return _closest_emotion


static func close_to_emotion(input_vec: Vector3, expected: StringName, difficulty: float) -> bool:
	var expected_vec: Vector3 = Emotion[expected]
	var valid_x: bool = abs(input_vec.x - expected_vec.x) < difficulty
	var valid_y: bool = abs(input_vec.y - expected_vec.y) < difficulty
	var valid_z: bool = abs(input_vec.z - expected_vec.z) < difficulty
	return valid_x && valid_y && valid_z
