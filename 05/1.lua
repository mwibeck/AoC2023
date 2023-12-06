#!/usr/local/bin/lua-5.1

args = {...}

local maps = {}
local seeds = {}

-- Read data. Using state machine.
local state

function readLine(l)
   if #l == 0 then return end
   
   local x, t = l:match("^(%S+)%s*([map]*:)")
   if x then state = x end
   if t == "map:" then
      maps[state] = {}
      return
   end

   if state == "seeds" then
      for n in l:gmatch("%d+") do
	 table.insert(seeds, tonumber(n))
      end
   else
      local to, from, len = l:match("(%d+)%s(%d+)%s(%d+)")
      table.insert(maps[state], {to=tonumber(to), from=tonumber(from), l=tonumber(len)})
   end
end

for line in io.lines(args[1]) do
   readLine(line)
end

-- Sort
for i,j in pairs(maps) do
   table.sort(j, function(x,y) return x.from < y.from end)
end

--[[
print(table.concat(seeds, ", "))
for i,j in pairs(maps) do
   print(i)
   for x,y in pairs(j) do
      print(y.from, y.to, y.l)
   end
end
--]]

-- lookup x-to-y, val is x value. Return y value
function lookup(x, y, val)
   local map = maps[x.."-to-"..y]
   -- linear search
   for i,j in ipairs(map) do
      if (j.from <= val) and (val <= j.from+j.l-1) then
	 return val - j.from + j.to
      end
   end
   -- Not found, just return
   return val
end

--
local chain = {"seed","soil","fertilizer","water","light","temperature","humidity","location"}

local low = math.huge

for _,seed in ipairs(seeds) do
   local val = seed
   for i = 1,#chain-1 do
      local v = lookup(chain[i],chain[i+1],val)
      print(chain[i], val, "->", chain[i+1], v)
      val = v
   end

   if val < low then
      low = val
   end
end

print(low)
