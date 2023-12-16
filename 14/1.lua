#!/usr/local/bin/lua-5.1

local args = {...}

local groups = {}

local y = 1
for l in io.lines(args[1]) do
   for x = 1,#l do
      if y == 1 then
	 groups[x] = {idx = 1, g = {0}}
      end
      
      local c = l:sub(x,x)

      if c == "O" then
	 groups[x].g[groups[x].idx] = groups[x].g[groups[x].idx] + 1
      elseif c == "#" then
	 groups[x].idx = groups[x].idx + 1
	 groups[x].g[groups[x].idx] = y
	 groups[x].idx = groups[x].idx + 1
	 groups[x].g[groups[x].idx] = 0
      end
   end
   y = y + 1
end

local load = 0

for x = 1,#groups do

   print(x, table.concat(groups[x].g,", "))
   
   local startWeight = y-1
   for i,g in ipairs(groups[x].g) do
      if i % 2 == 1 then -- O's
	 print(startWeight, g, g*(startWeight + startWeight-g+1) / 2)
	 load = load + g*(startWeight + startWeight-g+1) / 2
      else
	 -- # w
	 print(y-1, g, "weight:", y-1 - g)
	 startWeight = y-1 - g
      end
   end
end

print(load)
