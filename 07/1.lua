#!/usr/local/bin/lua-5.1

args = {...}


-- 5 of a kind        : 7
-- 4 of a kind        : 6
-- 3 + 2 of a kind    : 5
-- 3 of a kind        : 4
-- 2 + 2 of a kind    : 3
-- 2 of a kind (pair) : 2
-- nothing            : 1
-- A, K, Q, J, T, 9, 8, ... 2 change into F, E, D, C, B, 9, 8, .. for asciibetical order

-- Use "bucket"sorting to figure out hand.
function rank(h)
   local bucket = {}

   local a,b,c,d,e = h:match("(.)(.)(.)(.)(.)")
   
   bucket[a] = 1
   bucket[b] = (bucket[b] or 0) + 1
   bucket[c] = (bucket[c] or 0) + 1
   bucket[d] = (bucket[d] or 0) + 1
   bucket[e] = (bucket[e] or 0) + 1

   -- Number of each, at position x
--   print(bucket[a], bucket[b], bucket[c], bucket[d], bucket[e])

   local nums = {}
   local A,B,C,D,E = bucket[a], bucket[b], bucket[c], bucket[d], bucket[e]
   nums[A] = 1
   nums[B] = (nums[B] or 0) + 1
   nums[C] = (nums[C] or 0) + 1
   nums[D] = (nums[D] or 0) + 1
   nums[E] = (nums[E] or 0) + 1

--   print(nums[1], nums[2], nums[3], nums[4], nums[5])

   if nums[5] == 5 then
      return 7
   elseif nums[4] == 4 then
      return 6
   elseif nums[3] == 3 and nums[2] == 2 then
      return 5
   elseif nums[3] == 3 then
      return 4
   elseif nums[2] == 4 then
      return 3
   elseif nums[2] == 2 then
      return 2
   elseif nums[1] == 5 then
      return 1
   end
end

local hands = {}
local repl = {"1","2","3","4","5","6","7","8","9",T="B",J="C",Q="D",K="E",A="F"}

for l in io.lines(args[1]) do
   local hand, bid = l:match("(.....)%s(.+)$")
   hand = hand:gsub(".",repl)

   table.insert(hands, {hand=hand, bid=bid})
end

table.sort(hands,
	   function(l,r)
	      local lr,rr = rank(l.hand), rank(r.hand)
	      if lr == rr then
		 return l.hand < r.hand
	      end
	      return lr < rr
	   end
)

local total = 0

for i,j in ipairs(hands) do
   print(i, j.hand, j.bid)
   total = total + i * j.bid
end

print(total)
