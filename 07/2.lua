#!/usr/local/bin/lua-5.1

args = {...}


-- 5 of a kind        : 7
-- 4 of a kind        : 6
-- 3 + 2 of a kind    : 5
-- 3 of a kind        : 4
-- 2 + 2 of a kind    : 3
-- 2 of a kind (pair) : 2
-- nothing            : 1
-- A, K, Q, T, 9, 8, ... 2, J change into E, D, C, B, 9, 8, .., 2, 1 for asciibetical order

-- Use "bucket"sorting to figure out hand.
function rank(h)
   local bucket = {}

   local a,b,c,d,e = h.hand:match("(.)(.)(.)(.)(.)")

   local hand2,jokers = h.hand:gsub("1","")
   h.jokers = jokers

   if jokers == 1 then
      a,b,c,d = hand2:match("(.)(.)(.)(.)")
      e = 0
   elseif jokers == 2 then
      a,b,c = hand2:match("(.)(.)(.)")
      d = 0
      e = 0
   elseif jokers == 3 then
      a,b = hand2:match("(.)(.)")
      c = 0
      d = 0
      e = 0
   elseif jokers > 3 then
      h.val = 7
      return h.val
   end
   
   bucket[a] = 1
   bucket[b] = (bucket[b] or 0) + 1
   bucket[c] = jokers > 2 and 0 or ((bucket[c] or 0) + 1)
   bucket[d] = jokers > 1 and 0 or ((bucket[d] or 0) + 1)
   bucket[e] = jokers > 0 and 0 or ((bucket[e] or 0) + 1)
   
   -- Number of each, at position x
   --   print(bucket[a], bucket[b], bucket[c], bucket[d], bucket[e])

   local nums = {}
   local A,B,C,D,E = bucket[a], bucket[b], bucket[c], bucket[d], bucket[e]
   nums[A] = 1
   nums[B] = (nums[B] or 0) + 1
   nums[C] = jokers > 2 and 0 or ((nums[C] or 0) + 1)
   nums[D] = jokers > 1 and 0 or ((nums[D] or 0) + 1)
   nums[E] = jokers > 0 and 0 or ((nums[E] or 0) + 1)
   
   --   print(nums[1], nums[2], nums[3], nums[4], nums[5])

   if nums[5] == 5 then
      h.val = 7
   elseif nums[4] == 4 then
      if jokers > 0 then
	 h.val = 7
      else
	 h.val = 6
      end
   elseif nums[3] == 3 and nums[2] == 2 then
      h.val = 5
   elseif nums[3] == 3 then
      if jokers == 2 then
	 h.val = 7
      elseif jokers == 1 then
	 h.val = 6
      else
	 h.val = 4
      end
   elseif nums[2] == 4 then
      if jokers > 0 then
	 h.val = 5
      else
	 h.val = 3
      end
   elseif nums[2] == 2 then
      if jokers == 3 then
	 h.val = 7
      elseif jokers == 2 then
	 h.val = 6
      elseif jokers == 1 then
	 h.val = 4
      else
	 h.val = 2
      end
   else
      if jokers == 3 then
	 h.val = 6
      elseif jokers == 2 then
	 h.val = 4
      elseif jokers == 1 then
	 h.val = 2
      else
	 h.val = 1
      end
   end
   return h.val
end

local hands = {}
local repl = {"1","2","3","4","5","6","7","8","9",T="B",J="1",Q="C",K="D",A="E"}

for l in io.lines(args[1]) do
   local hand, bid = l:match("(.....)%s(.+)$")
   hand = hand:gsub(".",repl)

   table.insert(hands, {hand=hand, bid=bid})
end

table.sort(hands,
	   function(l,r)
	      local lr,rr = l.val or rank(l), r.val or rank(r)
	      if lr == rr then
		 return l.hand < r.hand
	      end
	      return lr < rr
	   end
)

local total = 0

for i,j in ipairs(hands) do
--   if j.jokers > 0 then print(i, j.hand, j.bid, j.val) end
   total = total + i * j.bid
end

print(total)
