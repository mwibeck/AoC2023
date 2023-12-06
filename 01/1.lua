#!/usr/local/bin/lua-5.1

args = {...}

local sum = 0
local debug = tonumber(args[2] or 0)

for line in io.lines(args[1]) do
   if debug > 1 then print(line) end
   local l = line:match("^%D*(%d)")
   local r = line:match("(%d)%D*$")
   if debug > 0 then print(l,r) end
   sum = sum + tonumber(l .. r)
end

print(sum)
