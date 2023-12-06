#!/usr/local/bin/lua-5.1

args = {...}

local sum = 0
local debug = tonumber(args[2] or 0)
local arr = {}

for line in io.lines(args[1]) do
   table.insert(arr, "." .. line .. ".")
end

table.insert(arr, 1, string.rep(".", #arr[1]))
table.insert(arr,    string.rep(".", #arr[1]))

function check(i, s, e)
   local above, mid, below
   above = arr[i-1]:sub(s-1,e+1):find("[^%.%d]")
   mid = arr[i]:sub(s-1,e+1):find("[^%.%d]")
   below = arr[i+1]:sub(s-1,e+1):find("[^%.%d]")

   return above or mid or below
end

for i,l in ipairs(arr) do
   local e = 0
   local s, partno
   repeat
      s,e = l:find("%d+", e+1)
      if s ~= nil then
	 partno = check(i,s,e) and tonumber(l:sub(s,e)) or 0
	 sum = sum + partno
      end
   until not s
end

print(sum)

