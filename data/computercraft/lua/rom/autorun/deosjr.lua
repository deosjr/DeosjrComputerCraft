-- /autorun DOES autoload still, unlike /programs
-- so this will be the new main way to test
-- (otherwise you need to reload using /datapacks disable/enable)
-- starts running once you inspect newly placed computer, or when otherwise turned on

term.clear()
term.setCursorPos(1,1)
print("welcome back")
-- surpress default welcome msg
--term.setTextColor(colors.black)

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

--local data = turtle.getItemDetail()
--print(dump(data))
function isTurtle()
	return turtle ~= nil
end

function selectEmptySlot()
	for i=1,16 do
		if turtle.getItemCount(i) == 0 then
			turtle.select(i)
			return
		end
	end
	error("no empty slots available")
end

-- errors if no empty slots
function getEquipped()
	selectEmptySlot()
	turtle.equipRight()
	local item = turtle.getItemDetail(turtle.getSelectedSlot())
	if not item then
		return nil
	end
	turtle.equipRight()
	return item.name
end

if fs.exists("startup.lua") then
	return
end

print("isturtle: "..tostring(isTurtle()))
if isTurtle() then
	item = getEquipped()
	if item == "minecraft:diamond_hoe" then
		shell.run("label set farmer")
		print("todo")
	elseif item == "minecraft:diamond_axe" then
		shell.run("label set bruce")
		shell.run("setstartup bruce")
		shell.run("startup.lua")
	elseif item == "minecraft:diamond_pickaxe" then
		shell.run("label set miner")
		print("place me somewhere i dont care")
	else
		shell.run("label set turtle")
		print("place me behind the lumberjack to get started")
	end
else
	shell.run("label set hal9000")
end