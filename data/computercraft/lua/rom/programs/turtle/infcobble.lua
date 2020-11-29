-- needs a cobblestone generator in front
-- and a chest beneath
-- does not require any power (never moves)

while true do
	if turtle.detect() then
		turtle.dig()
		while not turtle.dropDown() do
		end
	end
end