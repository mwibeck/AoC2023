#!/usr/local/bin/lua-5.1

args = {...}

local sum = 0
local debug = tonumber(args[2] or 0)

local words = {
   {"one","o1e"},
   {"two","t2o"},
   {"three","t3e"},
   {"four","4"},
   {"five","5e"},
   {"six","6"},
   {"seven","7n"},
   {"eight","e8t"},
   {"nine","n9e"},
}

for line in io.lines(args[1]) do
   if debug > 1 then print(line) end

   for i,word in ipairs(words) do
      line = line:gsub(word[1],word[2])
   end
   if debug > 1 then print(line) end
   
   local l = line:match("^%D*(%d)")
   local r = line:match("(%d)%D*$")

   if debug > 0 then print(l,r) end
   sum = sum + tonumber(l .. r)
end

print(sum)
