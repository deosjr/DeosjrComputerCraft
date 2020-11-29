-- once the lower wall pieces are in place
-- create the towers in the corners and at intervals
-- one by one for now, have to set the turtle at lowerleft
-- corner at the base of the wall

function buildTowerFace(faceNum)
	-- first 2 layers
	turtle.forward()
	turtle.turnRight()
	turtle.up()
	lib.placeDown(log)
	turtle.forward()
	lib.placeDown(stone)
	turtle.forward()
	lib.placeDown(log)
	turtle.forward()
	lib.placeDown(stone)
	local usedummy = false
	if not turtle.detect() then
		usedummy = true
	end
	if usedummy then
		lib.place(dummy)
	end
	turtle.back()
	lib.place(log)
	turtle.up()
	lib.placeDown(log)
	turtle.back()
	turtle.down()
	turtle.back()
	lib.place(log)
	turtle.up()
	lib.placeDown(log)

	-- now we go up and down
	turtle.turnLeft()
	turtle.back()
	local list = {brick, planks, planks, planks, brick, slab}
	for i=1,#list do
		if i ~= 1 then
			turtle.up()
		end
		lib.place(list[i])
	end
	lib.sidestepRight()
	turtle.down()
	turtle.forward()
	turtle.turnLeft()
	turtle.back()
	lib.place(stair)
	lib.sidestepLeft()
	turtle.forward()
	turtle.turnRight()
	list = {planks, brick, brick, brick}
	for i=1,#list do
		turtle.down()
		lib.place(list[i])
	end
	lib.sidestepRight()
	lib.place(slab)
	for i=1,3 do
		turtle.up()
	end
	lib.place(planks)
	turtle.up()
	turtle.forward()
	turtle.turnRight()
	turtle.forward()
	lib.placeDown(planks)
	turtle.back()
	lib.place(stair)
	turtle.turnLeft()
	turtle.back()
	lib.place(slab)
	lib.sidestepRight()
	turtle.down()
	list = {brick, brick, brick}
	for i=1,#list do
		turtle.down()
		lib.place(list[i])
	end

	-- finish upper slab in window and the inner floors
	turtle.up()
	lib.sidestepLeft()
	turtle.forward()
	lib.placeUp(slab)
	turtle.forward()
	turtle.down()
	lib.placeDown(stone)
	turtle.turnLeft()
	turtle.forward()
	lib.placeDown(stone)
	turtle.up()
	turtle.up()
	lib.placeUp(stone)
	turtle.back()
	lib.placeUp(stone)
	turtle.turnLeft()

	-- plug the hole in the floors at the end
	if faceNum == 4 then
		turtle.back()
		lib.placeUp(stone)
		turtle.down()
		turtle.down()
		lib.placeDown(stone)
		turtle.up()
		turtle.forward()
	else
		turtle.down()
	end

	turtle.forward()
	turtle.forward()
	turtle.turnRight()
	for i=1,3 do
		turtle.back()
		turtle.down()
		if usedummy and i == 2 then
			-- clean up the dummy block on the way back
			turtle.turnRight()
			turtle.dig()
			turtle.turnLeft()
		end
	end
	lib.sidestepRight()
end

stone = "minecraft:cobblestone"
log = "minecraft:spruce_log"
planks = "minecraft:spruce_planks"
slab = "minecraft:stone_brick_slab"
stair = "minecraft:stone_brick_stairs"
brick = "minecraft:stone_bricks"
-- used when we need to place against something
-- but that hasnt been built (yet)
-- note: to remove it, we need a mining turtle!
dummy = stone

-- uses 244 units of fuel + going up/down at start/end
-- which is 6 + 6 = 12 by default so make it 256 units :)
lib.refuelWithCoalIfNeeded(256)

mat = {}
mat[stone] = 26
mat[log] = 24
mat[planks] = 24
mat[slab] = 16
mat[stair] = 8
mat[brick] = 32
mat[dummy] = mat[dummy] + 1
lib.blockUntilMaterial(mat)

-- get in position
y = 0
while turtle.detect() do
	turtle.up()
	y = y + 1
end

for i=1,4 do
	buildTowerFace(i)
end

-- come back down
while y>0 do
	turtle.down()
	y = y - 1
end