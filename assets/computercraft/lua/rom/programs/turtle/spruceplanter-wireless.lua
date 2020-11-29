lib.refuel()
local modem = peripheral.wrap("right")
modem.open(1339)

-- starts above a chest with spruce saplings
while true do
	local event, modemSide, senderChannel, 
	  replyChannel, message, senderDistance = os.pullEvent("modem_message")

	if message == "goPlantSpruce" then

		turtle.select(2)
		turtle.suckDown()
		-- cant move through saplings so need to place from above
		turtle.up()

		turtle.forward()
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
		turtle.forward()
		turtle.forward()
		turtle.turnRight()
		turtle.forward()
		turtle.turnRight()

		turtle.down()
	end
end

-- reset select 1 to refuel from that slot
turtle.select(1)