#!/usr/local/bin/lua-5.1

args = {...}

local sum = 0
local debug = tonumber(args[2] or 0)

local max = {red=12, green=13, blue=14}

for line in io.lines(args[1]) do
   if debug > 2 then print(line) end

   local game, sets = line:match("Game (%d+): (.*)$")

   local red = 0
   sets:gsub("(%d+) red", function(x) red = math.max(red, x) end)
   local green = 0
   sets:gsub("(%d+) green", function(x) green = math.max(green, x) end)
   local blue = 0
   sets:gsub("(%d+) blue", function(x) blue = math.max(blue, x) end)

   local possible = red <= max.red and blue <= max.blue and green <= max.green
   
   if possible then
      sum = sum + game
   end
end

print(sum)
