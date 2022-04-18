extends Resource
class_name EnemyBomb

export(String) var enemyWeaponName = "bomb"
export(bool) var fallsFromAbove = true
export(float) var attackPeriod
export(float) var dmg
export(float) var flightTimePerTile = 0.0
export(float) var flightTimeBase = 0.5
#export(int) var shots
#export(float) var angle
export(float) var targetingRange = 10
#export(float) var randomAngle
#export(float) var scalex = 1.0
#export(float) var scaley = 1.0
export(float) var impactRadius = 2.5
#export(float) var spriteRotation = 0.0
#export(float) var spriteOffsetX = 0.5
#export(float) var spriteOffsetY = 0.5
#export(bool) var multihit = false
export(bool) var armorPierce = false
#export(bool) var ignoreWalls = false
#export(Texture) var sprite
export(Color) var modulate = Color(1, 0, 0)
export(float) var slowDuration = 0
export(float) var paralyzeDuration = 0
export(float) var darzaConfuseDuration = 0
export(float) var bursts = 1
export(float) var burstsAngleDiff = 0
export(float) var burstsDelay = 0
#export(float) var eachBulletRandomAngleDiff = 0
#export(bool) var followsEnemy = false
#export(float) var initialSpriteRotationSpeed = 0
#export(float) var bulletWaveFrequency = 0
#export(float) var bulletWaveAmplitude = 0
#export(bool) var rotateSpriteAndHitboxToMatchDirection = 0
