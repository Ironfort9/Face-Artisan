class_name EmotionTools
extends Node

# Using the 'PAD emotional state model' for the data
# x = Non-Arousal => Arousal | Goes from 0 -> 1
# y = Displeasure => Pleasure | Goes from 0 -> 1
# z = Dominance => Submissiveness | Goes from 0 -> 1
# w = Neutrality (Lack of any color, used to achieve intermediate values without 
#                 another value being dominant)
const Emotion: Dictionary[StringName, Vector3] = {
	# Center
	"NEUTRAL": Vector3(0.5, 0.5, 0.5),
	# Faces
	"DOMINANT": Vector3(0.5, 0.5, 0),
	"LETHARGIC": Vector3(0.5, 0, 0.5),
	"SAD": Vector3(0, 0.5, 0.5),
	"ALERT": Vector3(0.5, 1, 0.5),
	"HAPPY": Vector3(1, 0.5, 0.5),
	"POWERLESS": Vector3(0.5, 0.5, 1),
	# Corners
	"DEPRESSED": Vector3(0, 0, 1),
	"RELAXED": Vector3(1, 0, 1),
	"ANXIOUS": Vector3(0, 1, 1),
	"CONTEMPTUOUS": Vector3(0, 0, 0),
	"ADMIRYING": Vector3(1, 1, 1),
	"CONFIDENT": Vector3(1, 0, 0),
	"ANGRY": Vector3(0, 1, 0),
	"EXCITED": Vector3(1, 1, 0),
	# Edges
	"BORED": Vector3(0.5, 0, 1),
	"TENSE": Vector3(0.5, 1, 1),
	"COMPOSED": Vector3(0.5, 0, 0),
	"EXUBERANT": Vector3(0.5, 1, 0),
	"FEARFUL": Vector3(0, 0.5, 1),
	"COMPLIANT": Vector3(1, 0.5, 1),
	"DISGUSTED": Vector3(0, 0.5, 0),
	"DETERMINED": Vector3(1, 0.5, 0),
	"DESPAIRFUL": Vector3(0, 0, 0.5),
	"CALM": Vector3(1, 0, 0.5),
	"PANICKED": Vector3(0, 1, 0.5),
	"JOYFUL": Vector3(1, 1, 0.5),
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
		if GlobalFlags.debug:
			print(emotion_name + " => " + str(current_distance) + " | " + str(closest_distance))
		if current_distance < closest_distance:
			_closest_emotion = emotion_name
			closest_distance = current_distance
	return _closest_emotion


static func close_enough_to_emotion(input_vec: Vector3, expected: StringName, difficulty: float) -> bool:
	var expected_vec: Vector3 = Emotion[expected]
	var valid_x: bool = abs(input_vec.x - expected_vec.x) < difficulty
	var valid_y: bool = abs(input_vec.y - expected_vec.y) < difficulty
	var valid_z: bool = abs(input_vec.z - expected_vec.z) < difficulty
	return valid_x && valid_y && valid_z
