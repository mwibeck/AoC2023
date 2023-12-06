#!/usr/local/bin/lua-5.1

args = {...}

-- input
local times = {40829166}
local records = {277133813491063}
-- example
--local times = {71530}
--local records = {940200}

local product = 1
for a,b in ipairs(times) do
   local beats = 0
   for c = 0,b do
      if records[a] < (c * (b - c)) then
	 beats = beats + 1
      end
   end
   product = beats * product
end

print(product)

