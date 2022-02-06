extends Item
class_name Weapon

export(float) var dmg_min
export(float) var dmg_max
export(String) var tier
export(Texture) var bulletSprite 
export(float) var att_spd
export(float) var projectile_speed
export(float) var lifetime
export(int) var shots
export(float) var angle 
export(float) var scalex
export(float) var scaley
export(float) var collisionShapeRadius
export(float) var collisionShapeHeight
export(Color) var modulate = Color(1.0, 1.0, 1.0, 1.0)
export(float) var spriteRotation
export(float) var spriteOffsetX
export(float) var spriteOffsetY
export(bool) var multihit
export(bool) var armorPierce
export(bool) var ignoreWalls
export(String) var weaponType
export(String) var itemType = "weapon"
