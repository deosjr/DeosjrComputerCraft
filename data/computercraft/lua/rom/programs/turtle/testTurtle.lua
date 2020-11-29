function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

--turtle.equipLeft()
--[[
local modem = peripheral.wrap("right")
modem.open(1)
local event, modemSide, senderChannel, 
  replyChannel, message, senderDistance = os.pullEvent("modem_message")

print("I just received a message on channel: "..senderChannel)
print("I should apparently reply on channel: "..replyChannel)
print("The modem receiving this is located on my "..modemSide.." side")
print("The message was: "..message)
print("The sender is: "..(senderDistance or "an unknown number of").." blocks away from me.")
]]--
--local success, data = turtle.inspect()
--print(success, dump(data))
--local data = turtle.getItemDetail()
--print(dump(data))
--lib.reSelectItem("minecraft:stonebrick")
--print(rs.getAnalogInput("right"))
--stair = "minecraft:stone_brick_stairs"
--f = not turtle.place(stair)

--[[
stone = "minecraft:cobblestone"
variant1 = 5--"stone_brick"
variant2 = 3--"cobblestone"
stair = "minecraft:stone_stairs"
slab = "minecraft:stone_slab"
print(dump(lib.currentItem()))
print(turtle.detect())

lib.place(slab, variant2)
lib.placeUp(slab, variant1)
]]--
planks = "minecraft:planks"
slab = "minecraft:stone_slab"

turtle.dig()