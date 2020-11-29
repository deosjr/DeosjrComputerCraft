-- after imgur.com/a/NeywO
-- Great Ziggurat by @MCNoodlor

-- builds a wall of stone 2 layers high
-- does not lay the very first and very last stone
-- so bottom start and top end are not placed
function stonesTwoLayers(n)
	for i=1,(n-1) do
		turtle.back()
		lib.place(stone)
		lib.placeDown(stone)
	end
end

function placeStones(n)
	for i=1,(n-1) do
		lib.placeDown(stone)
		turtle.forward()
	end
	lib.placeDown(stone)
end

-- move back while laying front, down AND up
function threeInOne(n, mod)
	for i=1+mod,n+mod do
		turtle.back()
		if i%2==0 then
			lib.placeDown(planks)
		else
			lib.placeDown(stone)
		end
		lib.place(planks)
		if i%4==0 then
			lib.placeUp(brick)
		else
			lib.placeUp(slab_brick, slab_brick_damage)
		end
	end
end

-- arg parsing
-- ziggurat [deluxe] [phase]
-- causes error if not supplied with a parseable number
startFromPhase = 1
local deluxe = false
if arg[1] then
	if arg[1] == "deluxe" then
		deluxe = true
	else
		startFromPhase = math.floor(arg[1])
	end
end
if arg[2] then
	startFromPhase = math.floor(arg[2])
end

stone = "minecraft:cobblestone"
planks = "minecraft:planks"
slab_cobble = "minecraft:stone_slab"
slab_brick = "minecraft:stone_slab"
brick = "minecraft:stonebrick"
stair = "minecraft:stone_stairs"
torch = "minecraft:torch"
-- damage values. set to nil if dont want to check
-- todo: slabs can have different names too?
slab_cobble_damage = 3
slab_brick_damage = 5

if deluxe then
	stone = "minecraft:sandstone"
	planks = "minecraft:concrete" -- which also seem to differ in the damage value. purple is 10
	slab_cobble = "minecraft:stone_slab"
	slab_brick = "minecraft:stone_slab2"
	brick = "minecraft:red_sandstone"
	stair = "minecraft:sandstone_stairs"
	torch = "minecraft:torch"
	slab_cobble_damage = 1
	slab_brick_damage = nil
end

-- phase 1: ground floor walls and outer walkway
if not startFromPhase or startFromPhase <= 1 then
	lib.refuelWithCoalIfNeeded(368)
	print("DEBUG: remember, brick slabs")
	mat = {}
	mat[stone] = 269
	mat[planks] = 66
	mat[slab_brick] = 33
	mat[brick] = 11
	lib.blockUntilMaterial(mat)

	turtle.forward()
	turtle.up()
	turtle.turnRight()
	lib.placeDown(stone)
	stonesTwoLayers(37)
	turtle.turnRight()
	stonesTwoLayers(8)
	turtle.up()
	lib.placeDown(stone)
	turtle.up()
	lib.turnaround()
	lib.placeDown(stone)
	lib.placeUp(slab_brick, slab_brick_damage)
	threeInOne(7, 1)
	turtle.turnLeft()
	threeInOne(36, 0)
	turtle.turnLeft()
	turtle.back()
	lib.place(planks)
	-- now place 4 rows of stone
	turtle.up()
	turtle.turnRight()
	placeStones(36)
	lib.uturnRight()
	placeStones(36)
	lib.uturnLeft()
	placeStones(36)
	lib.uturnRight()
	placeStones(36)
	lib.turnaround()
	-- place wall foundation
	turtle.up()
	for i=1,6 do
		lib.placeDown(stone)
		turtle.forward()
		turtle.forward()
		turtle.forward()
		turtle.forward()
	end
	placeStones(9)
end
-- end of phase 1
-- we should now be able to safely build stairs
-- in the side of the wall, if we want to

-- go down until detectdown, build stone back up until planks in front,
-- then top it off with n stacks of planks + brick
function pillar(n)
	while not turtle.detectDown() do
		turtle.down()
	end
	planksDetected = false
	while not planksDetected do
		success, data = turtle.inspect()
		if success and data.name == planks then
			planksDetected = true
		else
			turtle.up()
			lib.placeDown(stone)
		end
	end
	for i=1,n do
		turtle.up()
		lib.placeDown(planks)
		turtle.up()
		lib.placeDown(brick)
	end
end

function build3x4block()
	lib.placeDown(stone)
	for i=1,2 do
		turtle.back()
		lib.placeDown(stone)
	end
	turtle.up()
	turtle.forward()
	turtle.forward()
	for i=1,3 do
		lib.placeDown(stone)
		lib.placeUp(slab_brick, slab_brick_damage)
		turtle.back()
		lib.place(planks)
	end
end

function buildPillars(n)
	for i=1,n do
		turtle.back()
		for j=1,3 do
			turtle.down()
		end
		build3x4block()
		if i == (n-1) or i == n then
			pillar(1)
		else
			pillar(2)
		end
	end
end

-- func when bottom of window reached
-- func when end of windows reached
-- num of window that should be different block, if any
function windows(bottomFunc, endFunc, diffColor)
	turtle.forward()
	lib.sidestepRight()
	for i=1,5 do
		turtle.down()
	end
	turtle.turnRight()
	turtle.back()
	-- build 6 stones, three left, down, then three right
	-- until we hit the ground
	-- every second time, place brick in the middle of lower layer
	-- fourth window is made of planks
	local moreWindows = true
	local windowsPlaced = 0
	while moreWindows do
		local stairsPlaced = false
		local windowMat = stone
		if diffColor and windowsPlaced == (diffColor - 1) then
			windowMat = planks
		end
		local i = 0
		while not turtle.detectDown() do
			lib.place(windowMat)
			lib.sidestepLeft()
			lib.place(windowMat)
			lib.sidestepLeft()
			lib.place(windowMat)
			turtle.down()
			lib.place(windowMat)
			if not stairsPlaced then
				turtle.turnLeft()
				lib.placeUp(stair)
				turtle.back()
				turtle.turnRight()
			else
				lib.sidestepRight()
			end
			if i%2==0 then
				lib.place(windowMat)
			else
				lib.place(brick)
			end
			turtle.turnRight()
	    	turtle.forward()
			if not stairsPlaced then
				lib.placeUp(stair)
				stairsPlaced = true
			end
			turtle.turnLeft()
			lib.place(windowMat)
			turtle.down()
			i = (i + 1) % 2
		end

		bottomFunc(windowMat)
		windowsPlaced = windowsPlaced + 1
		moreWindows = endFunc()
	end
end

function bottomFunc1(windowMat)
	-- place the last three blocks and find next window
	turtle.forward()
	turtle.turnRight()
	for i=1,3 do
		turtle.back()
		lib.place(windowMat)
	end
	turtle.back()
	turtle.turnRight()
end

function endFunc1()
-- turtle is looking through next window if any
	if turtle.detect() then
		return false
	end
	turtle.forward()
	lib.turnaround()
	repeat
		turtle.up()
	until turtle.detectUp()
	return true
end

-- start stairs
function backupback()
	turtle.back()
	turtle.up()
	turtle.back()
end

function stairpiece()
	lib.place(stone)
	lib.placeUp(slab_cobble, slab_cobble_damage)
end

-- starts in the left corner looking at the n-length side
function build3xNfloor(n)
	placeStones(n)
	lib.uturnRight()
	placeStones(n)
	lib.uturnLeft()
	placeStones(n)
end

function buildStairs()
	build3xNfloor(4)
	turtle.forward()
	lib.turnaround()
	turtle.down()

	stairsDone = false
	while not stairsDone do
		stairpiece()
		lib.sidestepRight()
		stairpiece()
		lib.sidestepRight()
		stairpiece()
		backupback()

		stairpiece()
		lib.sidestepLeft()
		stairpiece()
		lib.sidestepLeft()
		stairpiece()
		backupback()

		turtle.turnLeft()
		success, data = turtle.inspect()
		if success and data.name == planks then
			backupback()
			lib.sidestepRight()
			placeStones(3)
			stairsDone = true
		else
			turtle.turnRight()
		end
	end
end

function findBottomNextCorner()
	turtle.turnLeft()
	for i=1,4 do
		turtle.forward()
	end
	turtle.turnRight()
	while turtle.detect() do
		turtle.down()
	end
	turtle.up()
	turtle.up()
end

-- n is number of wall pieces
function buildUpperWalls(n)
	findBottomNextCorner()

	function slabblock()
		turtle.back()
		lib.place(slab_cobble, slab_cobble_damage)
		turtle.up()
		lib.placeDown(stone)
	end

	for i=1,(2*n-1) do
		slabblock()
		turtle.back()
	end
	slabblock()

	turtle.up()
	repeat
		turtle.forward()
	until turtle.detectDown()
	-- start wall up
	buildPillars(n)

	function bottomFunc2(windowMat)
		turtle.forward()
		turtle.turnLeft()
		turtle.forward()
		for i=1,2 do
			lib.place(windowMat)
			turtle.down()
		end
		lib.place(windowMat)
		turtle.back()
		lib.place(windowMat)
		for i=1,2 do
			turtle.up()
			lib.place(windowMat)
		end
		for i=1,3 do
			turtle.down()
			lib.placeUp(windowMat)
		end
		turtle.forward()
	end

	function endFunc2()
		-- turtle is looking at previous wall if we are done
		if turtle.detect() then
			-- hit a corner piece going up
			return false
		end
		turtle.forward()
		if turtle.detect() then
			-- hit a corner piece at equal height
			turtle.back()
			return false
		end
		turtle.forward()
		turtle.up()
		turtle.forward()
		turtle.turnLeft()
		turtle.forward()
		lib.turnaround()
		repeat
			turtle.up()
		until turtle.detectUp()
		return true
	end

	windows(bottomFunc2, endFunc2)

	lib.sidestepRight()
	repeat
		turtle.up()
	until not turtle.detect()
	for i=1,3 do
		turtle.up()
	end
	turtle.forward()
	turtle.turnLeft()
	turtle.back()
end

if not startFromPhase or startFromPhase <= 2 then
	-- phase 2: first wall and stairs up
	lib.refuelWithCoalIfNeeded(5000)
	print("DEBUG: remember, cobble AND brick slabs")
	mat = {}
	mat[stone] = 10*64 - 48
	mat[planks] = 2 * 64 - 36
	mat[slab_brick] = 64 - 19
	if slab_brick == slab_cobble then
		mat[slab_brick] = mat[slab_brick] + 64 - 8
	else
		mat[slab_cobble] = 64 - 8
	end
	mat[brick] = 64 - 16
	mat[stair] = 64 - 38
	lib.blockUntilMaterial(mat)

	lib.placeUp(brick)
	for i=1,3 do
		turtle.back()
		lib.placeUp(slab_brick, slab_brick_damage)
		lib.place(planks)
	end
	turtle.back()
	lib.place(planks)

	pillar(2)
	buildPillars(7)
	windows(bottomFunc1, endFunc1, 4)
	turtle.back()
	turtle.back()
	turtle.turnLeft()
	for i=1,10 do
		turtle.back()
	end
	buildStairs()
	buildUpperWalls(7)
end
-- end phase 2

-- phase 3: 
if not startFromPhase or startFromPhase <= 3 then
	lib.refuelWithCoalIfNeeded(5000)
	print("DEBUG: remember, cobble AND brick slabs")
	mat = {}
	mat[stone] = 6*64 - 15
	mat[planks] = 65
	mat[slab_brick] = 64 - 27
	if slab_brick == slab_cobble then
		mat[slab_brick] = mat[slab_brick] + 64 - 6
	else
		mat[slab_cobble] = 64 - 6
	end
	mat[brick] = 64 - 43
	mat[stair] = 64 - 48
	mat[torch] = 64 - 28
	lib.blockUntilMaterial(mat)

	turtle.turnLeft()
	buildStairs()
	buildUpperWalls(5)
	turtle.turnLeft()
	buildStairs()
	findBottomNextCorner()
	turtle.up()
	lib.placeDown(stone)
	turtle.up()
	for i=1,11 do
		lib.placeDown(stone)
		lib.placeUp(stone)
		turtle.back()
		lib.place(stone)
	end
	for i=1,3 do
		lib.placeDown(stone)
		turtle.up()
	end
	lib.turnaround()
	for i=0,10 do
		lib.placeDown(stone)
		if i%4==0 then
			lib.placeUp(brick)
		else
			lib.placeUp(slab_brick, slab_brick_damage)
		end
		turtle.back()
		lib.place(planks)
	end
	lib.placeDown(stone)
	lib.placeUp(slab_brick, slab_brick_damage)
	turtle.turnRight()
	turtle.back()
	lib.place(planks)
	turtle.up()
	turtle.back()
	turtle.back()
	turtle.turnLeft()
	build3xNfloor(9)
	turtle.forward()
	turtle.turnLeft()
	build3xNfloor(5)
	turtle.turnLeft()
	turtle.forward()
	lib.place(slab_brick, slab_brick_damage)
	turtle.back()
	lib.place(brick)

	turtle.turnLeft()
	turtle.up()
	for i=1,5 do
		turtle.forward()
	end
	turtle.turnLeft()
	function upperpillar()
		local list = {planks, planks, brick, stone}
		for i=1,#list do
			turtle.up()
			lib.placeDown(list[i])
		end
		turtle.back()
		lib.place(stone)
		turtle.down()
		lib.placeUp(stone)
		turtle.down()
		lib.placeUp(stair)
		lib.turnaround()
		turtle.forward()
		turtle.up()
		lib.placeUp(stone)
		turtle.forward()
		lib.placeUp(stone)
		turtle.down()
		lib.placeUp(stair)
	end
	upperpillar()
	turtle.forward()
	turtle.down()
	turtle.down()
	lib.turnaround()
	upperpillar()
	turtle.forward()
	turtle.down()
	turtle.down()
	turtle.turnLeft()
	upperpillar()
	turtle.turnRight()
	turtle.forward()
	for i=1,4 do
		turtle.up()
	end
	turtle.back()
	turtle.turnLeft()
	function upper3x3()
		for i=1,3 do
			if i%2==0 then
				lib.placeDown(planks)
			else
				lib.placeDown(stone)
			end
			lib.placeUp(slab_brick, slab_brick_damage)
			turtle.back()
			lib.place(planks)
		end
	end
	upper3x3()
	turtle.turnLeft()
	lib.placeDown(planks)
	lib.placeUp(brick)
	turtle.back()
	lib.place(planks)
	upper3x3()
	lib.placeDown(planks)
	lib.placeUp(brick)
	turtle.back()
	lib.place(planks)
	upper3x3()
	lib.placeDown(planks)
	lib.placeUp(brick)
	turtle.turnLeft()
	turtle.back()
	lib.place(planks)
	turtle.up()
	turtle.turnRight()
	build3xNfloor(8)
	lib.turnaround()
	for i=1,4 do
		turtle.forward()
	end
	lib.sidestepLeft()
	lib.placeDown(planks)
	for i=1,3 do
		turtle.forward()
		lib.placeDown(planks)
	end
	lib.turnaround()
	turtle.up()
	lib.placeDown(brick)
	for i=1,3 do
		turtle.forward()
		lib.placeDown(slab_brick, slab_brick_damage)
	end

	function placeTorchRow(n)
		for i=1,n do
			turtle.back()
			lib.place(torch)
			while not turtle.detectDown() do
				turtle.down()
			end
			for j=1,3 do
				turtle.back()
			end
		end
	end

	function placeTorchCrossFloor()
		turtle.back()
		lib.place(torch)
		for i=1,3 do
			turtle.back()
		end
		while not turtle.detectDown() do
			turtle.down()
		end
	end

	for i=1,3 do
		turtle.back()
	end
	turtle.turnRight()
	placeTorchCrossFloor()
	turtle.turnRight()
	placeTorchRow(3)
	turtle.turnRight()
	placeTorchRow(5)
	turtle.turnRight()
	placeTorchRow(7)
	turtle.turnRight()
	placeTorchRow(8)
	placeTorchCrossFloor()
	turtle.turnLeft()
	placeTorchRow(1)
	turtle.turnLeft()
	placeTorchRow(5)
	-- in case we pass over entry stairs
	placeTorchCrossFloor()
	placeTorchRow(3)
	turtle.turnRight()
	turtle.back()
	lib.place(torch)
	for i=1,5 do
		turtle.down()
	end
end