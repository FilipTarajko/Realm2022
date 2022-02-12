extends Item
class_name Weapon

export(float) var dmg_min
export(float) var dmg_max
export(String) var tier
export(Texture) var bulletSprite 
export(float) var rateOfFire = 1.0
export(float) var projectile_speed
export(float) var projectile_acceleration = 0.0
export(float) var lifetime
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
export(String) var weaponType
export(String) var itemType = "weapon"
export(float) var def = 0
export(float) var dex = 0
export(float) var hp = 0
export(float) var mp = 0
export(float) var spd = 0
export(float) var vit = 0
export(float) var wis = 0
export(float) var att = 0
export(float) var bulletWaveFrequency = 0
export(float) var bulletWaveAmplitude = 0
