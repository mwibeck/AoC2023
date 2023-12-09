#!/usr/local/bin/lua-5.1
args = {...}
local path
local nodes = {}
local nodesA = {}

for l in io.lines(args[1]) do
   local n,left,right = l:match("(.*) = %((.*), (.*)%)")
   if left == nil and #l > 0 then
      print("path len:", #l)
      path = l
   elseif n ~= nil then
      nodes[n] = {L=left, R=right}
      if n:sub(-1) == 'A' then
	 table.insert(nodesA, n)
	 print(n)
      end
   end
end


local max = 0

local idx = 1
local steps = 0
local new = {}
local node = nodesA
local cycle = {}

repeat
   dir = path:sub(idx,idx)
   
   new[1] = nodes[node[1]][dir]
   new[2] = nodes[node[2]][dir]
   new[3] = nodes[node[3]][dir]
   new[4] = nodes[node[4]][dir]
   new[5] = nodes[node[5]][dir]
   new[6] = nodes[node[6]][dir]

   node[1] = new[1]
   node[2] = new[2]
   node[3] = new[3]
   node[4] = new[4]
   node[5] = new[5]
   node[6] = new[6]

   idx = (idx % #path) + 1
   steps = steps + 1

   for i=1,6 do
      if node[i]:sub(-1) == "Z" then
	 print(i, node[i], steps)
	 cycle[i] = steps/#path
      end
   end

until cycle[1] and cycle[2] and cycle[3] and cycle[4] and cycle[5] and cycle[6]

for i=1,6 do
   print(node[i])
   print(table.concat(cycle,","))
end
print(cycle[1] * cycle[2] * cycle[3] * cycle[4] * cycle[5] * cycle[6] * #path )
