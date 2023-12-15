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


local b
local boxes = {}

for i = 0,255 do
   boxes[i] = {lenses = {}}
end

local function remove(b, l)
   for i,j in ipairs(b.lenses) do
      if l == j.label then
	 table.remove(b.lenses, i)
      end
   end
end

local function insert(b, l, fl)
   for i,j in ipairs(b.lenses) do
      if l == j.label then
	 table.remove(b.lenses, i)
	 table.insert(b.lenses, i, {fl=fl, label=l})
	 return
      end
   end
   table.insert(b.lenses, {fl=fl, label=l})
end

for input in io.lines(args[1]) do
   for val,op,arg in input:gmatch("(.-)([-=])(%d?),?") do
      box = hash(val)
      if op == '-' then
	 -- remove if present
	 remove(boxes[box], val)
      elseif op == '=' then
	 insert(boxes[box], val, arg)
      end
   end
end

local sumFL = 0

for i = 0,255 do
   for _,l in ipairs(boxes[i].lenses) do
      sumFL = sumFL + (1+i)*_*l.fl
   end
end

print(sumFL)
