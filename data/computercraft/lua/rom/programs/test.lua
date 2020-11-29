--local t = peripheral.wrap("right")

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

--print(dump(t))
--print(dump(t.list()))

--print(dump(t.getItem(1).getMetadata()))

-- range 0-15
--rs.setAnalogOutput("left", 12)
--print(peripheral.isPresent("back"))
local data = turtle.getItemDetail()
print(dump(data))