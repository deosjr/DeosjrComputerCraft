-- after imgur.com/a/dQmq1
-- Babel Walls by @MCNoodlor

-- starts on ground level facing left corner
-- takes 24 stone and 2 stair blocks
-- takes 28 fuel units and each turn between args takes 2 more
function buildLowerWallPiece()
	-- if you want to extend in the same direction, you can do that
	if turtle.detect() then
		lib.sidestepRight()
		turtle.forward()
		turtle.turnLeft()
	else
		turtle.forward()
		turtle.turnLeft()
		turtle.back()
	end
	for i=1,2 do
		lib.place(stone)
		turtle.turnRight()
		lib.place(stone)
		for j=1,2 do
			lib.sidestepRight()
			lib.place(stone)
		end
		turtle.up()
		lib.place(stone)
		for j=1,2 do
			lib.sidestepLeft()
			lib.place(stone)
		end
		turtle.turnLeft()
		lib.place(stone)
		turtle.up()
	end
	lib.place(stone)
	turtle.up()
	lib.place(stone)
	turtle.down()
	turtle.turnRight()
	lib.place(stone)
	lib.placeUp(stone)
	for i=1,2 do
		lib.sidestepRight()
		lib.place(stone)
		lib.placeUp(stone)
	end
	turtle.down()
	turtle.turnRight()
	lib.placeUp(stair)
	turtle.back()
	turtle.back()
	lib.turnaround()
	lib.placeUp(stair)
	-- go to next corner
	for i=1,3 do
		turtle.down()
		turtle.back()
	end
	turtle.turnRight()
	turtle.back()
end

-- if these are local then lib gets a nil value
stone = "minecraft:cobblestone"
stair = "minecraft:cobblestone_stairs"

-- should be called with
-- persianwall X LY RZ etc
-- where X Y Z are integers and L/R left or right
-- builds X pieces of wall, then turns left, builds Y pieces, etc

-- table of materials needed per wall segment
mat = {}
mat[stone] = 24
mat[stair] = 2

local a = 1
-- repeat the loop for each arg given
repeat
	local s = arg[a]
	local n = 0
	local dir = ""
	local fuel = 0
	if a == 1 then
		n = math.floor(s)
	else
		fuel = 2
		dir = string.sub(s, 1, 1)
		n = math.floor(string.sub(s, 2))
	end

	-- wait until we have enough fuel
	fuel = fuel + 28*n
	lib.refuelWithCoalIfNeeded(fuel)

	if not dir == "L" and not dir == "R" then
		error("incorrect direction: "..dir)
	end
	if dir == "L" then
		turtle.forward()
		turtle.turnLeft()
		turtle.back()
	elseif dir == "R" then
		turtle.forward()
		turtle.turnRight()
		turtle.back()
	end

	-- update mat needed
	local matNow = {}
	for k, v in pairs(mat) do
		matNow[k] = v * n
	end
	-- wait until we have enough
	lib.blockUntilMaterial(matNow)

	-- build pieces
	for i=1,n do
		buildLowerWallPiece()
	end
	a = a + 1
until arg[a] == nil