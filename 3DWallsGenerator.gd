extends Node


var layers = 20
var newScaleMultiplier = 1

# Changes wall heigth per layer
var scaleMultiplier = 1.01
# Changes wall heigth
#var highestLayerScaleMultiplier = 20.0
# Changes angle
var offsetMultiplier = 0.1
onready var HighTerrain = get_parent().get_node("HighTerrain")

func _ready():
	yield(get_tree(), "idle_frame")
	for _i in range(layers):
		var newHighTerrainLayer = HighTerrain.duplicate()
		newHighTerrainLayer.collision_mask = 0
		newHighTerrainLayer.collision_layer = 0
		newHighTerrainLayer.offsetMultiplier = offsetMultiplier
		
		# option 1, probably better
		newScaleMultiplier = scaleMultiplier * newScaleMultiplier
		# option 2
		#var newScaleMultiplier = ((highestLayerScaleMultiplier-1)/layers)*i+1
		# end
		
		newHighTerrainLayer.scale = Vector2(newScaleMultiplier, newScaleMultiplier)
		get_parent().add_child(newHighTerrainLayer)
