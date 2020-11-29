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
monitor = peripheral.wrap("right")
monitor.clear()
monitor.setCursorPos(1,1)
monitor.setTextColor(colors.green)
monitor.setBackgroundColor(colors.red)
monitor.write("hello")
monitor.setCursorPos(1,2)
monitor.blit("RAINBOW!","01234567","89abcdef")
monitor.write("hello")