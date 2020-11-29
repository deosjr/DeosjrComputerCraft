-- starts facing coal chest, then moves to plant saplings.
-- ends facing a 2x2 tree, facing north, on the rightmost square, then cuts it

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

while true do
	-- auto refuel from coal chest
	-- 1 unit of (char)coal gives 80 fuel units
	local coal = "minecraft:coal"
	local fuelNeeded = 160 - turtle.getFuelLevel()
	local coalNeeded = math.ceil(fuelNeeded / 80)
	local coalInInventory = lib.itemTotal(coal)
	if coalInInventory < coalNeeded then
		local coalStillNeeded = coalNeeded - coalInInventory
	    while coalStillNeeded > 0 do
	    	turtle.suck(coalStillNeeded)
	    	coalInInventory = lib.itemTotal(coal)
	    	coalStillNeeded = coalNeeded - coalInInventory
	    end
	end
    for i=1,16 do
        local data = turtle.getItemDetail(i)
        if data and data.name == coal then
            turtle.select(i)
            turtle.refuel()
        end
    end
    turtle.turnLeft()
    turtle.dig()
    turtle.forward()
    turtle.dig()
    turtle.forward()
    
    -- todo: spruce variant has damage 1, birch 2, etc
    -- big lumberjack only wants spruce
    local sapling = "minecraft:sapling"
    local spruce = 1
    local saplingsNeeded = 4
    local saplingsInInventory = lib.itemTotal(sapling, spruce)
    if saplingsInInventory < saplingsNeeded then
    	turtle.turnRight()
		local saplingsStillNeeded = saplingsNeeded - saplingsInInventory
	    while saplingsStillNeeded > 0 do
	    	turtle.suck(saplingsStillNeeded)
	    	saplingsInInventory = lib.itemTotal(sapling, spruce)
	    	saplingsStillNeeded = saplingsNeeded - saplingsInInventory
	    end
	    turtle.turnLeft()
	end
	turtle.turnLeft()
	turtle.digUp()
	turtle.up()
	turtle.forward()
	lib.placeDown(sapling, spruce)
	turtle.forward()
	lib.placeDown(sapling, spruce)
	lib.uturnLeft()
	lib.placeDown(sapling, spruce)
	turtle.forward()
	turtle.down()
	turtle.turnLeft()
	turtle.back()
	lib.place(sapling, spruce)

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
		local bonemeal = "minecraft:dye"
		local bonemealdmg = 15
		if lib.itemTotal(bonemeal, bonemealdmg) > 0 then
			lib.place(bonemeal, bonemealdmg)
			os.sleep(2)
		end
	end

	turtle.dig()
	turtle.forward()
	while turtle.detect() or turtle.detectUp() do
		digPlane()
		turtle.digUp()
		turtle.up()
		y = y+1
	end
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

	local log = "minecraft:log"
	repeat
		lib.dropAll(log)
	until lib.itemTotal(log) == 0
	turtle.turnLeft()
	turtle.dig()
	turtle.forward()
end