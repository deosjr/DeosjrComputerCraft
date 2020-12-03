-- library to write programs that continue running in between stopping and starting the game
-- writing any state to file and using instruction pointer to save where we are in script execution

function memFileName(programname)
	return programname.."-mem.lua"
end

function startFromMemory(programname)
	memfile = memFileName(programname)
	if fs.exists(memfile) then
		return dofile(memfile)
	end
	return nil
end

-- dump a table to string. copied from the internet somewhere (sry forgot where)
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

-- overwrites previous state
function writeMemory(programname, state)
	memfile = memFileName(programname)
	local f = fs.open(memfile, "w")
	f.write("return "..dump(state))
    f.close()
end

-- go x instructions forward (or back if negative)
function goto(i, x)
	return i + x - 1
end

function condJump(i, d, condition)
	if condition then
		return goto(i, d)
	end
	return i
end