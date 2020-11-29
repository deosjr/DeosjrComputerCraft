filename = arg[1]
if not filename then
	error("usage: setstartup filename")
end
shell.run("cp", "rom/programs/turtle/"..filename..".lua", "startup.lua")