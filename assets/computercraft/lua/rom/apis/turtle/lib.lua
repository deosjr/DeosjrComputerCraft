-- destroy and recreate a turtle to reload lib changes

function left(vx, vy)
    return vy*-1, vx
end

function right(vx, vy)
    return vy, vx*-1 
end

function turnLeft(vx, vy)
    turtle.turnLeft()
    return left(vx, vy)
end

function turnRight(vx, vy)
    turtle.turnRight()
    return right(vx, vy)
end

function currentSlotEmpty()
    return turtle.getItemCount(turtle.getSelectedSlot())==0
end

function allSlotsEmpty()
    local count = 0
    for i=1,16 do
        count = count + turtle.getItemCount(i)
    end
    return count == 0
end

function currentItem()
    return turtle.getItemDetail(turtle.getSelectedSlot())
end

function reSelect()
    for i=1,16 do
        if turtle.getItemCount(i) > 0 then
            turtle.select(i)
            return
        end
    end
    -- exit the program early
    error()
end

function reSelectItem(name, variant)
    for i=1,16 do
        local data = turtle.getItemDetail(i)
        if data and data.name == name then
            if not variant then
                turtle.select(i)
                return
            end
            if data.damage == variant then
                turtle.select(i)
                return
            end
        end
    end
    -- exit the program early
    if not variant then
        error("not found: "..name)
    end
    error("not found: "..name.." "..variant)
end

function tryReSelectItem(name)
    for i=1,16 do
        local data = turtle.getItemDetail(i)
        if data and data.name == name then
            turtle.select(i)
            return
        end
    end
    item = currentItem()
    if not item or item.name ~= name then
        return false
    end
    return true
end

-- items in inventory dont have state
-- hack to distinguish cobble from brick slab:
-- their damage value differs (3 vs 5)
function itemIsSelected(blockname, variant)
    local item = currentItem()
    if not item then
        return false
    end
    if item.name ~= blockname then
        return false
    end
    if not variant then
        return true
    end
    return item.damage == variant
end

function place(blockname, variant)
    if not itemIsSelected(blockname, variant) then
        reSelectItem(blockname, variant)
    end
    return turtle.place()
end

function placeUp(blockname, variant)
    if not itemIsSelected(blockname, variant) then
        reSelectItem(blockname, variant)
    end
    return turtle.placeUp()
end

function placeDown(blockname, variant)
    if not itemIsSelected(blockname, variant) then
        reSelectItem(blockname, variant)
    end
    return turtle.placeDown()
end

function tryPlace(blockname)
    item = currentItem()
    if not item or item.name ~= blockname then
        if not tryReSelectItem(blockname) then
            return false
        end
    end
    return turtle.place()
end

function sidestepLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
end

function sidestepRight()
    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
end

function turnaround()
    turtle.turnLeft()
    turtle.turnLeft()
end

function uturnLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
end

function uturnRight()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
end

function itemTotal(name, variant)
    local n = 0
    for i=1,16 do
        data = turtle.getItemDetail(i)
        if data and data.name == name then
            if not variant then
                n = n + data.count
            elseif data.damage == variant then
                n = n + data.count
            end
        end
    end
    return n
end

function materialNeeded(mat)
    local needed = {}
    local n = 0
    for k, v in pairs(mat) do
        local have = itemTotal(k)
        if have < v then
            needed[k] = v - have
            n = n + 1
        end
    end
    if n == 0 then
        return nil
    end
    return needed
end

function blockUntilMaterial(mat)
    while true do
        local needed = materialNeeded(mat)
        if not needed then
            return
        end
        for k, v in pairs(needed) do
            print("need "..v.." more of "..k)
        end
        print("-------------")
        os.sleep(0.1)
        os.pullEvent("turtle_inventory")
    end
end

function refuel()
    print(turtle.refuel())
end

function refuelWithCoalIfNeeded(needed)
    local missing = needed - turtle.getFuelLevel()
    if missing <= 0 then
        return
    end
    -- 1 unit of (char)coal gives 80 fuel units
    local coal = "minecraft:coal"
    local fuelNeeds = {}
    fuelNeeds[coal] = missing/80
    lib.blockUntilMaterial(fuelNeeds)
    for i=1,16 do
        local data = turtle.getItemDetail(i)
        if data and data.name == coal then
            turtle.select(i)
            turtle.refuel()
        end
    end
end

function dropAll(name, variant)
    for i=1,16 do
        data = turtle.getItemDetail(i)
        if data and data.name == name then
            if not variant then
                turtle.select(i)
                turtle.drop()
            elseif data.damage == variant then
                turtle.select(i)
                turtle.drop()
            end
        end
    end
end