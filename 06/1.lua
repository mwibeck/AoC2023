#!/usr/local/bin/lua-5.1

args = {...}

-- input
local times = {40, 82, 91, 66}
local records = {277, 1338, 1349, 1063}
-- example
--local times = {7, 15, 30}
--local records = {9, 40, 200}

function dist(time, press)
   return press * time - press * press
end

local product = 1
for a,b in ipairs(times) do
   local beats = 0
   for c = 0,b do
      if records[a] < dist(b,c) then
	 beats = beats + 1
      end
   end
   product = beats * product
end

print(product)

