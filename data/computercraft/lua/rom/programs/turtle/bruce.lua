local state = mem.startFromMemory("bruce")
if not state then
	state = {i=0}
end
local i = state.i

local stop = false -- used to communicate key Q pressed

local log = "minecraft:spruce_log"

-- if waiting for tree at startup, goto 1
if i == 1 then i = 0 end

local fuelLimit = 150

function checkTree()
	success, data = turtle.inspect()
	if success and data.name == log then
		return true
	end
	fuel = turtle.getFuelLevel()
	if fuel == 0 then
		print("Place me in front of a spruce tree to get started")
	elseif fuel < fuelLimit then
		print("I need to gather more fuel before we do anything else")
	else
		print("Okay one more tree and then let's get to business")
	end
	return false
end

function waitForTree()
	while true do
		success, data = turtle.inspect()
		if success and data.name == log then
			return
		end
		os.sleep(1)
	end
end

function refuelIfNeeded(amount)
	lib.reSelectItem(log)
	if not amount then
		turtle.refuel()
	else
		turtle.refuel(amount)
	end
	os.sleep(0.1)
end

action = {
	function () i = mem.condJump(i, 2, checkTree()) end,
	waitForTree,
	turtle.dig,
	-- repeated refuel check
	function () i = mem.condJump(i, 2, turtle.getFuelLevel() >= fuelLimit) end,
	function () refuelIfNeeded(1) end,
	--
	turtle.forward,
	function () i = mem.condJump(i, 6, not turtle.detectUp()) end,
	turtle.digUp,
	-- repeated refuel check
	function () i = mem.condJump(i, 2, turtle.getFuelLevel() >= fuelLimit) end,
	function () refuelIfNeeded(1) end,
	--
	turtle.up,
	function () i = mem.goto(i, -5) end,
	function () i = mem.condJump(i, 5, turtle.detectDown()) end,
	-- repeated refuel check
	function () i = mem.condJump(i, 2, turtle.getFuelLevel() >= fuelLimit) end,
	refuelIfNeeded,
	--
	turtle.down,
	function () i = mem.goto(i, -4) end,
}

function main()
	while not stop do
		-- table is 1-based, modulo arithmetic is 0-based
		action[i+1]()
		i = ((i + 1) % #action)
		state.i = i
		mem.writeMemory("bruce", state)
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