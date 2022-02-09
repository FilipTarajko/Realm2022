extends TileMap

onready var player = get_parent().get_node("Player")

var offsetMultiplier = 0

func _ready():
	pass # Replace with function body.

func _process(_delta):
	global_position = -(scale.x-1)/(1)* player.global_position - Vector2(0, (scale.y-1)*100*offsetMultiplier).rotated(player.rotation)
