#!/usr/local/bin/lua-5.1

local args = {...}
local grid = {}
local energy = {}

local MAXX, MAXY

local dot = string.byte(".")
local dash = string.byte("-")
local pipe = string.byte("|")
local fmirr = string.byte("/")
local bmirr = string.byte("\\")

local y = 0
for l in io.lines(args[1]) do
   y = y + 1
   grid[y] = {l:byte(1,-1)}
   
   energy[y] = { string.rep("\0",#l):byte(1,-1) }
end

local energized = 0

local MAXX = #grid[1]
local MAXY = y

local NORTH = 2
local EAST = 3
local SOUTH = 5
local WEST = 7

local function raytrace(x,y,dir)
   if x > MAXX or y > MAXY or x < 1 or y < 1 then return end

   if energy[y][x] == 0 then
      energized = energized + 1
      energy[y][x] = dir
   elseif energy[y][x] % dir == 0 then
      -- been here before.
      return
   else
      energy[y][x] = energy[y][x] * dir
   end

   local c = grid[y][x]
   if dir == NORTH then
      if c == dot or c == pipe then
	 raytrace(x,y-1,dir)
      elseif c == dash then
	 raytrace(x-1,y,WEST)
	 raytrace(x+1,y,EAST)
      elseif c == fmirr then
	 raytrace(x+1,y,EAST)
      elseif c == bmirr then
	 raytrace(x-1,y,WEST)	 
      end
   elseif dir == EAST then
      if c == dot or c == dash then
	 raytrace(x+1,y,dir)
      elseif c == pipe then
	 raytrace(x,y-1,NORTH)
	 raytrace(x,y+1,SOUTH)
      elseif c == fmirr then
	 raytrace(x,y-1,NORTH)
      elseif c == bmirr then
	 raytrace(x,y+1,SOUTH)	 
      end
   elseif dir == SOUTH then
      if c == dot or c == pipe then
	 raytrace(x,y+1,dir)
      elseif c == dash then
	 raytrace(x-1,y,WEST)
	 raytrace(x+1,y,EAST)
      elseif c == fmirr then
	 raytrace(x-1,y,WEST)
      elseif c == bmirr then
	 raytrace(x+1,y,EAST)	 
      end
   elseif dir == WEST then
      if c == dot or c == dash then
	 raytrace(x-1,y,dir)
      elseif c == pipe then
	 raytrace(x,y-1,NORTH)
	 raytrace(x,y+1,SOUTH)
      elseif c == fmirr then
	 raytrace(x,y+1,SOUTH)
      elseif c == bmirr then
	 raytrace(x,y-1,NORTH)	 
      end
   end
end

local maxenergy = 0

local function zerogrid()
   energized = 0
   for y=1,MAXY do
      energy[y] = { string.rep("\0",MAXX):byte(1,-1) }
   end
end

for x=1,MAXX do
   zerogrid()
   raytrace(x,1,SOUTH)
   print(x,1,"SOUTH",energized)
   maxenergy = math.max(maxenergy, energized)

   zerogrid()
   raytrace(x,MAXY,NORTH)
   print(x,MAXY,"NORTH",energized)
   maxenergy = math.max(maxenergy, energized)
end

for y=1,MAXY do
   zerogrid()
   raytrace(1,y,EAST)
   print(1,y,"EAST",energized)
   maxenergy = math.max(maxenergy, energized)

   zerogrid()
   raytrace(MAXX,y,WEST)
   print(MAXX,y,"WEST",energized)
   maxenergy = math.max(maxenergy, energized)
end

print(maxenergy)
