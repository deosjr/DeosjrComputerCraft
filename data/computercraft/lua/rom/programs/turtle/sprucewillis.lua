-- starts facing coal chest, then moves to plant saplings.
-- ends facing a 2x2 tree, facing north, on the rightmost square, then cuts it

-- these three states need to be stored in mem
local i = 0 -- instruction pointer
local y = 0 -- current relative height
local side = "right" -- used in digPlane
local stop = false -- used to communicate key Q pressed

local sapling = "minecraft:spruce_sapling"
local spruce = nil --1
local log = "minecraft:spruce_log"
local bonemeal = "minecraft:bone_meal"
local bonemealdmg = nil --15
local coal = "minecraft:charcoal"

local memfile = "sprucewillis.mem"

if fs.exists(memfile) then
   local f = fs.open(memfile, "r")
   i = tonumber(f.readLine())
   y = tonumber(f.readLine())
   side = f.readLine()
   f.close()
end

function writemem()
	local f = fs.open(memfile, "w")
	f.write(tostring(i).."\n")
	f.write(tostring(y).."\n")
	f.write(side)
    f.close()
end

-- The largest jungle and spruce trees reach 31 blocks tall.
-- we can calculate needed fuel level based on that
-- each y level needs 2 fuel: one to reach (up) and one forward (so 62)
-- then we have the initial forward and the last back (+2),
-- and going all the way down again (+31)
-- we need max 95 fuel, so lets refuel if we are below 160 (2 coal)

-- needs room to grow: 3x3 on sapling level (around nw sapling)
-- 5x5 for at least 14 blocks above the saplings

-- how to detect tree has grown without obstructing?
-- -> just make sure not to stand on the nw side when you come back

function placeSapling()
	lib.place(sapling, spruce)
end

-- var side is the side turtle is on. need to turn to other side
function turnSide()
	if side == "left" then
		turtle.turnRight()
	elseif side == "right" then
		turtle.turnLeft()
	else
		error("variable 'side' is "..side)
	end
end

function changeSide()
	if side == "left" then
		side = "right"
	elseif side == "right" then
		side = "left"
	else
		error("variable 'side' is "..side)
	end
end

function moveDown()
	while y > 0 do
		local success, data = turtle.inspectDown()
		if success then
			if data.name == "minecraft:chest" then
				error("DEBUG: almost cut down chest!")
			end
			turtle.digDown()
		end
		turtle.down()
		y = y-1
	end
end

function dropLogs()
	repeat
		lib.dropAll(log)
	until lib.itemTotal(log) == 0
end

function refuelFromChest()
	-- auto refuel from coal chest
	-- 1 unit of (char)coal gives 80 fuel units
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
end

function saplingsFromChest()
    local saplingsNeeded = 4
    local saplingsInInventory = lib.itemTotal(sapling, spruce)
	local saplingsStillNeeded = saplingsNeeded - saplingsInInventory
    while saplingsStillNeeded > 0 do
    	turtle.suck(saplingsStillNeeded)
    	saplingsInInventory = lib.itemTotal(sapling, spruce)
    	saplingsStillNeeded = saplingsNeeded - saplingsInInventory
    end
end

function waitForTree()
	local treeDetected = false
	while not treeDetected do
		success, data = turtle.inspect()
		if success and data.name == log then
			treeDetected = true
		end
		if lib.itemTotal(bonemeal, bonemealdmg) > 0 then
			lib.place(bonemeal, bonemealdmg)
			os.sleep(2)
		end
	end
end

function condJump(d, condition)
	if condition then
		i = i + d
	end
end

-- go x instructions forward (or back if negative)
function goto(x)
	i = i + x - 1
end

action = {
	refuelFromChest,
	turtle.turnLeft,
	turtle.dig,
	turtle.forward,
	turtle.dig,
	turtle.forward,
	function () condJump(3, lib.itemTotal(sapling, spruce) >= 4) end,
	turtle.turnRight,
	saplingsFromChest,
	turtle.turnLeft,
	-- start placing saplings
	turtle.turnRight,
	turtle.back,
	placeSapling,
	turtle.turnLeft,
	turtle.back,
	placeSapling,
	turtle.turnLeft,
	turtle.back,
	placeSapling,
	turtle.turnRight,
	turtle.back,
	placeSapling,
	-- done placing saplings
	waitForTree,
	turtle.dig,
	turtle.forward,
	function () condJump(9, not turtle.detect() and not turtle.detectUp()) end,
	-- start digplane
	turtle.dig,
	turnSide,
	turtle.dig,
	function () 
		changeSide()
		turtle.forward()
	end,
	turnSide,
	turtle.dig,
	turtle.digUp,
	function () 
		turtle.up()
		y = y + 1
	end,
	-- end digplane
	function () goto(-9) end,
	function () condJump(3, side == "right") end,
	turnSide,
	function () 
		changeSide()
		turtle.forward()
	end,
	turnSide,
	turtle.turnLeft,
	turtle.turnLeft,
	turtle.dig,
	turtle.forward,
	moveDown,
	turtle.turnRight,
	dropLogs,
	turtle.turnLeft,
	turtle.turnLeft,
}

function main()
	while not stop do
		-- table is 1-based, modulo arithmetic is 0-based
		action[i+1]()
		i = ((i + 1) % #action)
		writemem()
	end
end

function keyInterrupt()
	while true do
		local event, key, isHeld = os.pullEvent("key")
		if key == keys.q then
			stop = true
			break
		end
	end
end

parallel.waitForAny(main, keyInterrupt)