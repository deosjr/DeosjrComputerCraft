lib.refuel()

function waitForSignal()
	while redstone.getAnalogInput("left") ~= 15 do
		sleep(1)
	end
end

while true do
	waitForSignal()
	-- starts above a chest with spruce saplings
	turtle.select(2)
	turtle.suckDown()
	-- cant move through saplings so need to place from above
	turtle.digUp()
	turtle.up()

	turtle.forward()
	turtle.placeDown()
	turtle.forward()
	turtle.placeDown()
	turtle.turnRight()
	turtle.forward()
	turtle.placeDown()
	turtle.turnRight()
	turtle.forward()
	turtle.placeDown()
	turtle.dig()
	turtle.forward()
	turtle.turnRight()
	turtle.forward()
	turtle.turnRight()

	turtle.down()
end

-- reset select 1 to refuel from that slot
turtle.select(1)