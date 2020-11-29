local modem = peripheral.wrap("right")
modem.open(1337)

while true do
	local event, modemSide, senderChannel, 
	  replyChannel, message, senderDistance = os.pullEvent("modem_message")

	if message == "treeCut" then
		modem.transmit(1339, 1340, "goPlantSpruce")
	end
end