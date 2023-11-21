extends CharacterBody3D



func collide(object : Node):
	print("collide")
	if object.name == "Key":
		rotation_degrees.y = 90
