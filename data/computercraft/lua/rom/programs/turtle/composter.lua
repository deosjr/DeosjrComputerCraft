-- builds a composting stack:
-- chest (input compostable)
-- hopper
-- composter
-- hopper -> chest (output bonemeal)

local hopper = "minecraft:hopper"
local chest = "minecraft:chest"
local composter = "minecraft:composter"

mat = {}
mat[chest] = 2
mat[hopper] = 2
mat[composter] = 1
lib.blockUntilMaterial(mat)
lib.refuelWithCoalIfNeeded(10)

lib.tryPlace(chest)
turtle.back()
lib.tryPlace(hopper)
turtle.up()
lib.tryPlace(composter)
turtle.up()
lib.tryPlace(hopper)
turtle.up()
lib.tryPlace(chest)
turtle.down()
turtle.down()
turtle.down()