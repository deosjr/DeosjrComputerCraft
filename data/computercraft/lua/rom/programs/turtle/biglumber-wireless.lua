-- starts facing a tree, facing north, on the rightmost square

local y = 0
local side = "right"

-- The largest jungle and spruce trees reach 31 blocks tall.
-- we can calculate needed fuel level based on that
-- each y level needs 2 fuel: one to reach (up) and one forward (so 62)
-- then we have the initial forward and the last back (+2),
-- and going all the way down again (+31)
-- we need max 95 fuel, so lets refuel if we are below 100 

function digPlane()
	if side == "right" then
		turtle.dig()
		turtle.turnLeft()
		turtle.dig()
		turtle.forward()
		turtle.turnRight()
		turtle.dig()
		side = "left"
	elseif side == "left" then
		turtle.dig()
		turtle.turnRight()
		turtle.dig()
		turtle.forward()
		turtle.turnLeft()
		turtle.dig()
		side = "right"
	end
end

local modem = peripheral.wrap("right")

while true do

	if turtle.getFuelLevel() < 100 then
		lib.refuel()
	end

	-- needs room to grow: 3x3 on sapling level (around nw sapling)
	-- 5x5 for at least 14 blocks above the saplings

	-- how to detect tree has grown without obstructing?
	-- -> just make sure not to stand on the nw side when you come back

	local treeDetected = false
	while not treeDetected do
		success, data = turtle.inspect()
		if success and data.name == "minecraft:log" then
			treeDetected = true
		end
	end

	turtle.dig()
	turtle.forward()
	while turtle.detectUp() do
		digPlane()
		turtle.digUp()
		turtle.up()
		y = y+1
	end
	-- dig one last time
	digPlane()
	-- end on the right
	if side == "left" then
		turtle.turnRight()
		turtle.forward()
		turtle.turnLeft()
		side = "right"
	end
	-- turn around
	turtle.turnLeft()
	turtle.turnLeft()
	-- we need to remove leaves in the way, if any
	turtle.dig()
	turtle.forward()
	while y > 0 do
		turtle.digDown()
		turtle.down()
		y = y-1
	end
	-- turn around again
	turtle.turnLeft()
	turtle.turnLeft()

	-- notify controller
	modem.transmit(1337, 1338, "treeCut")
end