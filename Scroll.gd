extends Ability
class_name Scroll

export(String) var abilityType = "scroll"
export(float) var dmg_min
export(float) var dmg_max
export(Texture) var bulletSprite
export(float) var projectile_speed = 12
export(float) var lifetime = 0.5
export(int) var shots
export(float) var angle
export(float) var scalex = 1
export(float) var scaley = 1
export(float) var collisionShapeRadius
export(float) var collisionShapeHeight
export(Color) var modulate = Color(1.0, 1.0, 1.0, 1.0)
export(float) var spriteRotation
export(float) var spriteOffsetX
export(float) var spriteOffsetY
export(bool) var multihit
export(bool) var armorPierce
export(bool) var ignoreWalls
export(String) var additionalUsageInfo = "bullets appear on mouse"
