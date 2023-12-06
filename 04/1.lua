#!/usr/local/bin/lua-5.1

args = {...}

local sum = 0
local debug = tonumber(args[2] or 0)
local arr = {}


function cardPoints(l)
   local points
   local win,num = l:match(":([%d%s]+)|([%d%s]+)$")
   for n in num:gmatch("%d+") do
      if win:find(" " .. n .. " ") then
	 points = (points or 0.5) * 2
      end
   end
   return points or 0
end

for line in io.lines(args[1]) do
   sum = sum + cardPoints(line)
end

print(sum)
