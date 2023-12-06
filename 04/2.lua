#!/usr/local/bin/lua-5.1

args = {...}

local sum = 0
local debug = tonumber(args[2] or 0)
local arr = {}

local myCards = {}

function readCard(l)
   local x = 0
   local card,win,num = l:match("(%d+):([%d%s]+)|([%d%s]+)$")
   card = tonumber(card)
   myCards[card] = {n=1, win={}}

   for n in num:gmatch("%d+") do
      if win:find(" " .. n .. " ") then
	 x = x+1
	 table.insert(myCards[card].win, card+x)
      end
   end
  print(string.format("Card %d, wins: %s", card, table.concat(myCards[card].win, ",")))
end

for line in io.lines(args[1]) do
   readCard(line)
end

function coll(c)
   for i,j in pairs(c.win) do
      myCards[j].n = myCards[j].n + c.n
   end
end

print(#myCards)

for i = 1, #myCards do
   print(i, myCards[i].n)
   sum = sum + myCards[i].n
   coll(myCards[i])
end

print(sum)
