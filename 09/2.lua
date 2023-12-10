#!/usr/local/bin/lua-5.1
args = {...}

history = {}

for l in io.lines(args[1]) do
   local vals = {}

   for val in l:gmatch("-?%d+") do
      table.insert(vals, tonumber(val))
   end

   table.insert(history,vals)
   print(table.concat(vals," "))
end

local bigsum = 0

for i,vals in ipairs(history) do

   local diffs = {}
   local allZ

   local curr = {unpack(vals)}
   local sum = 0

   print("current", table.concat(curr,"-"))
   -- Calc all diffs
   repeat
 
      local diff = {}
      allZ = true
      -- one level
      for j=1,#curr-1 do
	 diff[j] = curr[j+1] - curr[j]
	 allZ = allZ and (diff[j] == 0)
      end
      if not allZ then
	 table.insert(diffs,diff)
	 print(table.concat(diff,"."))
	 curr = {unpack(diff)}
      end
   until allZ

   for x = #diffs,1,-1 do
      sum = diffs[x][1] - sum
   end

   print("Prev:", vals[1]-sum)
   bigsum = bigsum + (vals[1]-sum)
end
print("sum of prevs", bigsum)
