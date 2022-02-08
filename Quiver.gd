extends Ability
class_name Quiver

export(String) var abilityType = "quiver"
export(float) var dmg_min
export(float) var dmg_max
export(Texture) var bulletSprite
export(float) var projectile_speed = 20.0
export(float) var projectile_acceleration = 0.0
export(float) var lifetime = 0.4
export(int) var shots
export(float) var angle
export(float) var scalex = 0.8
export(float) var scaley = 0.8
export(float) var collisionShapeRadius
export(float) var collisionShapeHeight
export(Color) var modulate = Color(1.0, 1.0, 1.0, 1.0)
export(float) var spriteRotation
export(float) var spriteOffsetX = 0.5
export(float) var spriteOffsetY = 0.5
export(bool) var multihit = true
export(bool) var armorPierce
export(bool) var ignoreWalls
export(float) var slowDuration = 0.0
export(float) var paralyzeDuration = 0.0
