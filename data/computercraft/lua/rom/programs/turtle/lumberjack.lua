local y = 0

-- starts on a 4x4 platform with 4 spruce/birch trees planted in corners
-- will chop all of them down

function chopTree()
	while not turtle.detect() do
	end
	turtle.dig()
	turtle.forward()
	while turtle.detectUp() do
		turtle.digUp()
		turtle.up()
		y = y+1
	end
	while y > 0 do
		turtle.down()
		y = y-1
	end
	turtle.turnRight()
	turtle.forward()
	turtle.forward()
end

-- todo should check in between each action, really
while true do
	if turtle.getFuelLevel() < 15 then
		turtle.refuel()
	end
	chopTree()
end