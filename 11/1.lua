#!/usr/local/bin/lua-5.1
args = {...}

local map = {}
local galax = {}
local usedX = {}
local y = 1
local found
local maxX

for l in io.lines(args[1]) do

   maxX = #l
   
   found = false
   -- Find galaxies in this line
   for x in l:gmatch("#()") do
      table.insert(galax, {x=x-1,y=y})
      found = true

      print(x-1, y)
      
      -- keep list of used x-coords, to expand the unused ones later
      usedX[x-1] = true
   end

   -- check for empty lines, duplicate them
   if not found then
      print(y, "empty")
      y = y + 1
   end
   
   y = y + 1
end

-- Calc how much x should move as a function of original x position
local ex = {}
local offs = 0

for x = 1,maxX do
   if not usedX[x] then
      offs = offs + 1
   end
   ex[x] = offs
end


-- expand vertical space
for i,g in ipairs(galax) do
   g.x = g.x + ex[g.x]
end

-- Loop through all galaxy-pairs, summing all dist (abs(x2-x1) + abs(y2-y1))
local dist
local sum = 0

for a,b in ipairs(galax) do
   print(a, b.x, b.y)
   for c = a + 1,#galax do
      dist = math.abs(b.x-galax[c].x) + math.abs(b.y-galax[c].y)
      sum = dist + sum
--      print(a, c, dist)
   end
end

print(sum)
