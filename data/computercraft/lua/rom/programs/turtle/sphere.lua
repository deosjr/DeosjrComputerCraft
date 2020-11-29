-- build a circle of radius using any material
-- and stack it maxy layers high

lib.refuel()

local radius = 3
local intRadius = 0
local n = 0
local pixels = {}
local posx, posy = 0, 0
local vx, vy = 0, 0

function setpixel(table, n, x, y)
    local tx = math.floor(n/2)+x
    local ty = math.floor(n/2)+y 
        
    table[ty+1][tx+1] = 'x'
end

function init(radius)

    intRadius = math.floor(radius)
    n = 2*(intRadius+1) + 1

    -- go up and move past the circle
    turtle.up()
    for i=1,intRadius+1 do
        turtle.forward()
    end
    turtle.turnLeft()     

    pixels = {}
    -- set empty spaces to dot
    for y=1,n do
        pixels[y] = {}
        for x=1,n do
            pixels[y][x] = '.'
        end
    end
    posx, posy = intRadius+2, n
    vx, vy = -1, 0

    -- fill in circle pixels
    local l = math.floor(radius * math.cos(math.pi/4))

    for x=0,l do
        y = math.floor(math.sqrt(radius*radius - x*x))
        setpixel(pixels, n, x, y)
        setpixel(pixels, n, -x, y)
        setpixel(pixels, n, x, -y)
        setpixel(pixels, n, -x, -y)
        setpixel(pixels, n, y, x)
        setpixel(pixels, n, -y, x)
        setpixel(pixels, n, y, -x)
        setpixel(pixels, n, -y, -x)
    end
   
end

function printGrid(table) 
    for y=1,#table do
        for x=1,#table do
            write(table[y][x])
        end
        print()
    end
end

function pixelLeft()
    vvx, vvy = lib.left(vx, vy)
    xx, yy = posx+vvx, posy+vvy
    if (xx < 1) or (xx >= n) then
        return false
    end
    if (yy < 1) or (yy >= n) then
        return false
    end
    return pixels[yy][xx] == 'x' 
end

function pixelForward()
    xx, yy = posx+vx, posy+vy
    if (xx < 1) or (xx >= n) then
        return false
    end
    if (yy < 1) or (yy >= n) then
        return false
    end
    return pixels[yy][xx] == 'x'
end

function moveAndPlace()
    posx, posy = posx+vx, posy+vy
    turtle.forward()
    if lib.currentSlotEmpty() then
        lib.reSelect()
    end
    turtle.placeDown()
    return posx, posy
end

function mainLoop()
    if pixelLeft() then
        if pixelForward() then
            vx, vy = lib.turnRight(vx, vy)
        end
    else
        vx, vy = lib.turnLeft(vx, vy)
    end
    posx, posy = moveAndPlace()
end

function drawCircle()
    -- one circle in xz plane
    repeat
        mainLoop()
    until (posx==intRadius+2) and (posy==n)
    turtle.turnRight()
    for i=1,intRadius+1 do
        turtle.back()
    end
end

for i=3,5 do
    radius = i
    init(radius)
    printGrid(pixels)
    drawCircle()
    print('one more layer finished!')
end
for i=4,3,-1 do
    radius = i
    init(radius)
    printGrid(pixels)
    drawCircle()
    print('one more layer finished!')
end
print('done! :)')