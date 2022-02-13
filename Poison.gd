extends Ability
class_name Poison

export(String) var abilityType = "poison"
export(float) var dmg_min
export(float) var dmg_max
export(bool) var fallsFromAbove = false
export(float) var flightTimePerTile = 0.0
export(float) var flightTimeBase = 0.5
export(float) var impactRadius = 2.5
export(bool) var armorPierce = true
export(Color) var modulate = Color(1, 1, 1)
export(float) var slowDuration = 0
export(float) var paralyzeDuration = 0
export(String) var additionalUsageInfo = "throws poison at mouse"
