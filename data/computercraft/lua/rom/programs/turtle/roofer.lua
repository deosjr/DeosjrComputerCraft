-- simple roof:
-- assumes it is placed in front of a rectangular building
-- facing a wall in the left lower corner
-- top level of the building should be a rectangular outline
-- covers the entire rectangle with a flat roof

function turnDir(dir)
	if not dir == "L" and not dir == "R" then
		error("incorrect direction: "..dir)
	end
	if dir == "L" then
		turtle.turnLeft()
	elseif dir == "R" then
		turtle.turnRight()
	end
end

function otherDir(dir)
	if not dir == "L" and not dir == "R" then
		error("incorrect direction: "..dir)
	end
	if dir == "L" then
		return "R"
	elseif dir == "R" then
		return "L"
	end
end

turtle.refuel()
brick = "minecraft:stonebrick"
dir = "R"

-- get in position
y = 0
while turtle.detect() do
	turtle.up()
	y = y + 1
end
turtle.forward()
turnDir(dir)
turnDir(dir)

function firstOrLastPass()
	repeat
		lib.place(brick)
		turtle.back()
		turtle.down()
	until turtle.detect()
	turtle.up()
	lib.place(brick)
	turnDir(dir)
	turtle.back()
	turnDir(dir)
	turtle.back()
	dir = otherDir(dir)
end

function regularPass()
	repeat
		lib.place(brick)
		turtle.back()
	until turtle.detectDown()
	lib.place(brick)
	turnDir(dir)
	turtle.back()
	lib.place(brick)
	turnDir(dir)
	dir = otherDir(dir)
end

-- each step should place turtle above a block for next row at the end
-- if it doesnt we are finished building the roof
repeat
	turtle.back()
	local firstOrLast = turtle.detectDown()
	if firstOrLast then
		firstOrLastPass()
	else
		regularPass()
	end
until not turtle.detectDown()

-- come back down
while y>0 do
	turtle.down()
end