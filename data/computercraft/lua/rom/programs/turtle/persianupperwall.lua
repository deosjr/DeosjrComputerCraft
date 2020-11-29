-- starts at the _right_ lower corner of a tower
-- connects to towers and finishes the top of a wall
-- needs a pickaxe because it will modify the tower base

-- walking backwards, try placing stair, slab, reverse stair, brick
function placeFringe()
	endReached = false
	while not endReached do
		turtle.back()
		lib.place(stair)
		turtle.back()
		lib.turnaround()
		-- returns false when no more bricks or cant place brick
		endReached = not lib.tryPlace(brick)
		turtle.back()
		lib.place(stair)
		turtle.up()
		lib.placeDown(slab)
		turtle.forward()
		if not endReached then
			turtle.forward()
			turtle.forward()
			lib.turnaround()
			lib.place(slab)
			turtle.down()
		end
	end
end

function placeFloorRow()
	repeat
		lib.placeDown(stone)
		turtle.forward()
	until turtle.detect()
	lib.placeDown(stone)
end

-- place stone floor
function placeFloor()
	turtle.down()
	lib.turnaround()
	placeFloorRow()
	turtle.turnRight()
	turtle.forward()
	turtle.turnRight()
	placeFloorRow()
	turtle.turnLeft()
	turtle.forward()
	turtle.turnLeft()
	placeFloorRow()
end

stone = "minecraft:cobblestone"
log = "minecraft:spruce_log"
slab = "minecraft:stone_brick_slab"
stair = "minecraft:stone_brick_stairs"
brick = "minecraft:stone_bricks"

-- initial fuel needs are for finding the opposite tower
-- and coming back. Maybe make an optional arg for it?
lib.refuelWithCoalIfNeeded(200)

-- move up until we see a brick, moving past the logs
-- default persiantower from base of wall, y should be 8
canStart = false
y = 0
while not canStart do
	success, data = turtle.inspect()
	if success and data.name == brick then
		canStart = true
	else
		turtle.up()
		y = y + 1
	end
end

-- figure out how far next tower is
-- and report back with fuel/material needs
lib.sidestepRight()
turtle.forward()
turtle.turnRight()
x = 1
while not turtle.detect() do
	turtle.forward()
	x = x + 1
end
lib.turnaround()
for i=1,(x-1) do
	turtle.forward()
end
lib.sidestepLeft()
turtle.forward()
turtle.turnRight()
for i=1,y do
	turtle.down()
end
print("found other tower with "..x.." steps in between")

-- calculate material costs
-- there are n = (x+1)/4 wall segments in between the towers
-- we need n 3x5 base pieces and n-1 1x5 mid pieces
-- not included in cost: recovering material from tower base
-- reclaims 4 stone and 8 logs
num3x5 = (x+1)/4
num1x5 = num3x5-1

-- looks like this is incorrect. serves as an okay upper bound though
const = 47
base = (2*4*(x-1))-2
fringes = 2*(8*(num3x5-1)+5)
floor = 3*(x-1)
needed = base + fringes + floor + x + const
print("fuel needed: "..needed)
lib.refuelWithCoalIfNeeded(needed)

mat3x5 = {}
mat3x5[stone] = 13
mat3x5[log] = 8
mat3x5[slab] = 2
mat3x5[stair] = 4
--mat3x5[brick] = 0
mat1x5 = {}
mat1x5[stone] = 3
mat1x5[log] = 4
mat1x5[slab] = 2
--mat1x5[stair] = 0
mat1x5[brick] = 2
mat = {}
mat[stone] = num3x5 * mat3x5[stone] + num1x5 * mat1x5[stone] + 6
mat[log] = num3x5 * mat3x5[log] + num1x5 * mat1x5[log]
mat[slab] = num3x5 * mat3x5[slab] + num1x5 * mat1x5[slab]
mat[stair] = num3x5 * mat3x5[stair]
mat[brick] = num1x5 * mat1x5[brick]
lib.blockUntilMaterial(mat)

-- actually start, from initial start position
for i=1,y do
	turtle.up()
end
lib.sidestepRight()
turtle.forward()
turtle.turnLeft()
-- now we do the following twice: 
-- build the side of the upper wall until the next tower
-- and modify that tower base. ending up
for i=1,2 do
	turtle.down()
	lib.placeDown(stone)
	turtle.back()
	repeat
		lib.place(log)
		lib.placeDown(log)
		turtle.up()
		lib.placeDown(log)
		turtle.back()
		turtle.down()
		lib.placeDown(stone)
		turtle.back()
	until turtle.detectDown()
	-- we ran into the other tower and are still hovering over the last stone
	-- remove the last log and place from there
	turtle.dig()
	turtle.forward()
	lib.turnaround()
	lib.place(log)
	turtle.up()
	lib.placeDown(log)
	turtle.forward()
	lib.sidestepLeft()
	turtle.down()
	-- modifying tower base
	turtle.dig()
	lib.place(stone)
	turtle.down()
	turtle.dig()
	lib.sidestepLeft()
	turtle.dig()
	turtle.up()
	turtle.dig()
	lib.place(stone)
	lib.sidestepLeft()
	turtle.dig()
	lib.place(stone)
	turtle.down()
	turtle.dig()
	turtle.up()
	turtle.up()
	lib.sidestepLeft()
end
-- now we place the top fringe and the wall roof/floor
placeFringe()
lib.sidestepLeft()
placeFloor()
lib.sidestepRight()
placeFringe()

-- come back down
turtle.turnLeft()
for i=1,4 do
	turtle.back()
end
turtle.turnRight()
for i=1,(x-1) do
	turtle.back()
end
turtle.turnLeft()
turtle.back()
-- for some reason we end one higher?
while (y+1)>0 do
	turtle.down()
	y = y - 1
end