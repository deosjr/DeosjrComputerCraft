-- starts at bottomleft corner of the 45x45x43 ziggurat
-- places indicators; startpositions for 4 turtles
-- that should each run ziggurat.lua to build
-- and midpoint of the ziggurat
-- builds the main entry stairs as soon as
-- turtle has built door on this side

function forwardN(n)
	for i=1,n do
		turtle.forward()
	end
end

indicator = "minecraft:stonebrick"
-- arg parsing
-- plan-ziggurat [deluxe] [indicatorblockid]
local deluxe = false
if arg[1] then
	if arg[1] == "deluxe" then
		deluxe = true
	else
		indicator = "minecraft:"..arg[1]
	end
end
if arg[2] then
	indicator = "minecraft:"..arg[2]
end

-- todo communicate these to other turtles?
stone = "minecraft:cobblestone"
planks = "minecraft:spruce_planks"
slab_cobble = "minecraft:cobblestone_slab"
slab_brick = "minecraft:stone_brick_slab"
stair = "minecraft:stone_brick_stairs"
brick = "minecraft:stone_bricks"
torch = "minecraft:torch"
-- damage values. set to nil if dont want to check
-- todo: slabs can have different names too?
-- outdated in 1.16.4
slab_cobble_damage = nil --3
slab_brick_damage = nil --5

if deluxe then
	stone = "minecraft:sandstone"
	planks = "minecraft:purple_concrete"
	slab_cobble = "minecraft:sandstone_slab"
	slab_brick = "minecraft:red_sandstone_slab"
	brick = "minecraft:red_sandstone"
	stair = "minecraft:sandstone_stairs"
	torch = "minecraft:torch"
end

mat = {}
-- todo: rewrite so that stone is mined before it is placed?
mat[stone] = 26 -- reclaims 23 after
mat[planks] = 3 --reclaims 1 at the end
mat[slab_brick] = 4 --brick slab, reclaims 1 at the end
mat[stair] = 12
if mat[indicator] then
	mat[indicator] = mat[indicator] + 5
else
	mat[indicator] = 5
end
lib.blockUntilMaterial(mat)

lib.refuelWithCoalIfNeeded(400)

turtle.turnRight()
-- walk to next point, place it, and turn the corner
for i=1,4 do
	forwardN(36)
	turtle.digDown()
	lib.placeDown(indicator)
	forwardN(9)
	turtle.turnLeft()
	turtle.forward()
end
forwardN(22)
turtle.turnLeft()
forwardN(23)
turtle.digDown()
lib.placeDown(indicator)
lib.turnaround()
forwardN(16)
for i=1,5 do
	turtle.up()
end

-- now block until we can start building entry staircase
-- lower wall should be done by that point, so at least
-- the door in front should be finished
local success, data
repeat
	success, data = turtle.inspect()
until success and data.name == planks
-- give builder time to finish the door first
os.sleep(20)
turtle.dig()
turtle.down()
turtle.dig()
for i=1,3 do
	turtle.down()
end
for i=1,5 do
	turtle.forward()
end
turtle.turnLeft()
turtle.forward()
turtle.forward()
turtle.turnRight()

function sidewallStairs()
	for i=1,3 do
		lib.placeDown(stone)
		if i%2==0 then
			lib.placeUp(planks)
		else
			lib.placeUp(stone)
		end
		turtle.back()
		lib.place(stone)
	end
end

sidewallStairs()
turtle.up()
for i=1,3 do
	lib.sidestepRight()
	lib.place(stone)
end
turtle.down()
turtle.forward()
lib.place(stone)
for i=1,2 do
	lib.sidestepLeft()
	lib.place(stone)
end
turtle.down()
turtle.forward()
lib.place(stone)
for i=1,2 do
	lib.sidestepRight()
	lib.place(stone)
end
lib.sidestepRight()
turtle.up()
turtle.forward()
sidewallStairs()
turtle.back()
turtle.turnLeft()
turtle.forward()
turtle.forward()
turtle.turnRight()
for i=1,3 do
	turtle.up()
end
lib.placeDown(stone)
turtle.forward()
for i=1,3 do
	turtle.forward()
	turtle.digDown()
end
turtle.dig()
turtle.forward()
for i=1,4 do
	turtle.digDown()
	turtle.down()
end

turtle.turnRight()
turtle.dig()
turtle.forward()
turtle.digUp()
for i=1,3 do
	turtle.up()
	turtle.digUp()
end
turtle.turnRight()

function cutsides(start, stop)
	for i=start,stop do
		turtle.dig()
		turtle.forward()
		if i ~= 4 then
			turtle.turnLeft()
		end
		turtle.dig()
		lib.place(planks)
		turtle.up()
		lib.place(slab_brick, slab_brick_damage)
		turtle.down()
		turtle.turnRight()
	end
end

cutsides(1,3)
turtle.turnRight()
turtle.forward()
cutsides(4,6)
turtle.dig()
turtle.forward()
turtle.digUp()
for i=1,3 do
	turtle.digDown()
	turtle.down()
end
lib.turnaround()
turtle.back()

for i=1,2 do
	lib.place(stair)
	lib.sidestepLeft()
	lib.place(stair)
	lib.sidestepLeft()
	lib.place(stair)
	turtle.up()
	turtle.forward()
	lib.place(stair)
	lib.sidestepRight()
	lib.place(stair)
	lib.sidestepRight()
	lib.place(stair)
	turtle.up()
	turtle.forward()
end