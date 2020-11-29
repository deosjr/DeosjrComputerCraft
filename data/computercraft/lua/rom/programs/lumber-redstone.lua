-- sends redstone signals to communicate with lumberjack and planter
-- 0 is baseline, 15 means go do something

-- waits for a lumberjack at the back, sends a signal, 
-- and wait for the lumberjack to leave
function goCutTree()
	while not peripheral.isPresent("back") do
		sleep(1)
	end
	redstone.setAnalogOutput("back", 15)
	while peripheral.isPresent("back") do
		sleep(1)
	end
	redstone.setAnalogOutput("back", 0)
end

function waitForLumberjackToComeBack()
	while not peripheral.isPresent("back") do
		sleep(1)
	end
end

-- waits for a planter to the right, sends a signal,
-- and wait for the planter to leave
function goPlantSapling()
	while not peripheral.isPresent("right") do
		sleep(1)
	end
	redstone.setAnalogOutput("right", 15)
	while peripheral.isPresent("right") do
		sleep(1)
	end
	redstone.setAnalogOutput("right", 0)
end

redstone.setAnalogOutput("back", 0)
redstone.setAnalogOutput("right", 0)
while true do
	goCutTree()
	waitForLumberjackToComeBack()
	goPlantSapling()
end