#!/usr/local/bin/lua-5.1

local args = {...}

local function hash(s)
   local val = 0

   local ascii = {s:byte(1,-1)}

   for i,c in ipairs(ascii) do
      val = val + c
      val = val * 17
      val = val % 256
   end
   return val
end

print(hash("HASH"))

local myHash = 0
for input in io.lines(args[1]) do
   for val in input:gmatch("([^,\n]*)") do
      myHash = myHash + hash(val)
   end
end

print(myHash)
