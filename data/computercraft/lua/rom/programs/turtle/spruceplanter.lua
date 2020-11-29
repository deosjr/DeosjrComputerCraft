lib.refuel()

-- starts above a chest with spruce saplings
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

-- reset select 1 to refuel from that slot
turtle.select(1)