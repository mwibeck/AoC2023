#!/usr/local/bin/lua-5.1
args = {...}

local world = {}
local dist = {}
local start
local y = 0
local max = math.huge

for l in io.lines(args[1]) do
   y = y + 1

   local t={}
   local d={}
   for i = 1,#l do
      table.insert(t, l:sub(i,i))
      table.insert(d, ".")
   end

   table.insert(world, t)
   table.insert(dist, d)

   if not start then
      local s,e = l:find("S")
      if s then
        start = {x=s,y=y}
        dist[y][s] = 0
      end
   end
end

local turn = {}
turn["N"] = {["7"]="W", ["F"]="E", ["|"]="N"}
turn["E"] = {["J"]="N", ["7"]="S", ["-"]="E"}
turn["S"] = {["L"]="E", ["J"]="W", ["|"]="S"}
turn["W"] = {["L"]="N", ["F"]="S", ["-"]="W"}
local done = false

function step(x, y, src)
   local nx, ny = x, y
   if src == "N" then
      ny = ny - 1
   elseif src == "E" then
      nx = nx + 1
   elseif src == "S" then
      ny = ny + 1
   else
      nx = nx - 1
   end

   local d = dist[y][x]
   local pipe = world[ny][nx]
   local dir = turn[src][pipe]

   if dir then
      if dist[ny][nx] ~= "." then
	 -- been here before.
	 print(dist[ny][nx], d + 1)
	 done = true
	 return
      else
	 dist[ny][nx] = d + 1
      end
   end
   return nx, ny, dir
end

-- step in every direction
local xN,yN,dN = step(start.x, start.y, "N")
local xE,yE,dE = step(start.x, start.y, "E")
local xS,yS,dS = step(start.x, start.y, "S")
local xW,yW,dW = step(start.x, start.y, "W")

local x = {}
local y = {}
local d = {}
local idx = 1

-- Pretty boring and not my best code. But it works.
if dN then
   x[idx],y[idx],d[idx] = xN,yN,dN
   idx = idx + 1
end
if dE then
   x[idx],y[idx],d[idx] = xE,yE,dE
   idx = idx + 1
end
if dS then
   x[idx],y[idx],d[idx] = xS,yS,dS
   idx = idx + 1
end
if dW then
   x[idx],y[idx],d[idx] = xW,yW,dW
end

if dN and dE then
   world[start.y][start.x] = "L"
elseif dN and dS then
   world[start.y][start.x] = "|"
elseif dN and dW then
   world[start.y][start.x] = "J"
elseif dE and dS then
   world[start.y][start.x] = "F"
elseif dE and dW then
   world[start.y][start.x] = "-"
elseif dS and dW then
   world[start.y][start.x] = "7"
end

x1,y1,d1 = x[1],y[1],d[1]
x2,y2,d2 = x[2],y[2],d[2]

-- End of boring code.

repeat
   x1,y1,d1 = step(x1,y1,d1)
   x2,y2,d2 = step(x2,y2,d2)
until done

local enclosed = 0
local last

local swap = {F="J", L="7"}

local outside 
for y,i in ipairs(dist) do
  outside = true
  last = nil
  for x,j in ipairs(i) do
    if j ~= "." then
      local pipe = world[y][x]
      if pipe == "|" then
        outside = not outside
      elseif pipe == "F" or pipe == "L" then
        last = pipe
      elseif pipe == "J" or pipe == "7" then
        if swap[last] == pipe then
          outside = not outside
        end
        last = nil
      end
    else
      if not outside then
	    enclosed = enclosed + 1
	    dist[y][x] = "I"
      end
    end
  end
end

for y,i in ipairs(dist) do
  print(table.concat(i,"\t"))
end

print(enclosed)

