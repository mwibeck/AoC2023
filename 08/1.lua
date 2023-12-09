#!/usr/local/bin/lua-5.1
args = {...}
local path
local nodes = {}

for l in io.lines(args[1]) do
  local n,left,right = l:match("(.*) = %((.*), (.*)%)")
  print(n,left,right)
  if left == nil and #l > 2 then
    path = l
  elseif n ~= nil then
    nodes[n] = {L=left, R=right}
  end
end

local idx = 1
local steps = 0
local node = "AAA"
local new

repeat
  dir = path:sub(idx,idx)
  new = nodes[node][dir]

  print(node, dir, new, idx)

  node = new
  idx = (idx % #path) + 1
  steps = steps + 1
  print(node)
until new == "ZZZ"

print(steps)
