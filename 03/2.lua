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

local w = #arr[1] -- width

local gears = {}

function mark(y, x, n)
   gears[y*w + x] = gears[y*w + x] or {}
   table.insert(gears[y*w + x], n)
   print("mark line/x", y, x, n, #gears[y*w + x])
end


function check(i, s, e, n)
   local above, mid, below
   above = arr[i-1]:sub(s-1,e+1):find("%*")
   mid = arr[i]:sub(s-1,e+1):find("%*")
   below = arr[i+1]:sub(s-1,e+1):find("%*")

   if above then
      mark(i-1, above+(s-1)-1, n)
   end
   if mid then
      mark(i, mid+(s-1)-1, n)
   end
   if below then
      mark(i+1, below+(s-1)-1, n)
   end
end

for i,l in ipairs(arr) do
   local e = 0
   local s, partno
   repeat
      s,e = l:find("%d+", e+1)
      if s ~= nil then
	 partno = check(i,s,e,tonumber(l:sub(s,e)))
      end
   until not s
end

for i,j in pairs(gears) do
   if #j == 2 then
      sum = sum + j[1] * j[2]
   end
end

print(sum)

