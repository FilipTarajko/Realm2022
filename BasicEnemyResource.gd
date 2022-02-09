extends Resource
class_name BasicEnemyResource

export(String) var enemyName
export(Texture) var sprite
export(float) var moveSpeed
export(float) var escapeRange = 0.2
export(float) var visionRange = 13
export(float) var followRange = 1
export(bool) var doesDodge
export(float) var chaseRandomMaxAngle
export(Color) var modulate = Color(1, 1, 1)
export(float) var scalex = 1.0
export(float) var scaley = 1.0
export(float) var maxHp
export(float) var shadowSizeMultiplier = 1.0
export(float) var hpRegen = 0
export(Array, Resource) var weapons = []
export(bool) var isUsing16pxSprite = false
