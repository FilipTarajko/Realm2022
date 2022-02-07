extends Resource
class_name BasicEnemyResource

export(String) var enemyName
export(Texture) var sprite
export(float) var moveSpeed
export(float) var escapeRange
export(float) var visionRange
export(float) var followRange
export(bool) var doesDodge
export(float) var chaseRandomMaxAngle
export(Color) var modulate = Color(1, 1, 1)
export(float) var scalex = 1.0
export(float) var scaley = 1.0
export(float) var maxHp
export(float) var shadowSizeMultiplier = 1.0
export(float) var hpRegen = 0
export(Array, Resource) var weapons = []
