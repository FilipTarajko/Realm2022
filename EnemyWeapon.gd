extends Resource
class_name EnemyWeapon

export(String) var enemyWeaponName
export(float) var att_spd
export(float) var dmg_min
export(float) var dmg_max
export(float) var projectile_speed
export(float) var lifetime
export(int) var shots
export(float) var angle
export(float) var targetingRange
export(float) var randomAngle
export(float) var scalex = 1.0
export(float) var scaley = 1.0
export(float) var collisionShapeRadius = 2.5
export(float) var collisionShapeHeight = 14.0
export(float) var spriteRotation = 0.0
export(float) var spriteOffsetX = 0.5
export(float) var spriteOffsetY = 0.5
export(bool) var multihit = false
export(Texture) var sprite
export(Color) var modulate = Color(1, 1, 1)
