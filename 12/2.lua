#!/usr/local/bin/lua-5.1
args = {...}

local sub = string.sub
local find = string.find

-- Line is like: ???.###  ? - unknown. . - empty # - spring
-- instance is {{s=starting pos, l=length of run}, ... }
-- Returns 0 if instance cannot fit in line
--         1 if instance is a possible solution
local function check(line, instance)
   local last = 1
   for idx,i in ipairs(instance) do

      -- check for # before this run
      if find(sub(line, last, i.s-1),"#",1,true) then
	 return 0
      end

      -- no .'s in run.
      if find(sub(line,i.s, i.s + i.l - 1), ".",1,true) then
	 return 0
      end
      last = i.s + i.l
   end

   -- No # after last 'run'
   if find(sub(line,last),"#",1,true) then
      return 0
   end
   
   return 1
end

local function inst_ts(instance)
   local s = string.rep(".",instance[1].s-1)
   for i=1,#instance do
      s = s .. string.rep("#",instance[i].l)
      if i < #instance then
	 s = s .. string.rep(".", instance[i+1].s - #s - 1)
      end
   end
   return s
end

local function step(line, instance)
   local i = #instance
   local inst = instance
   local used_len = inst[i].l
   local x = false
   local len = #line
   
   repeat
      local nextX = line:find(string.rep("[^%.]", inst[i].l), inst[i].s+1)
      if nextX and (nextX + used_len - 1 <= len) then
	 inst[i].s = nextX
	 if i+1 <= #instance then
	    for x = i+1,#instance do
	       inst[x].s = inst[x-1].s + 1 + inst[x-1].l
	    end
	 end
--	 print(inst_ts(inst))
	 return inst
      else
--	 print("backtrace", i, used_len, i > 1 and inst[i-1].l or 0)
	 -- cannot move this more. Step previous.
	 if i > 1 then
	    used_len = used_len + 1 + inst[i-1].l
	    i = i - 1
	 else
	    x = true
	 end
      end
   until x
   
   return nil
end


local sum = 0
local LINES, CHECKS = 0,0

for l in io.lines(args[1]) do
   local line,g = l:match("([%?%.%#]*) ([%d,]*)$")

   line = table.concat({line,line,line,line,line}, "?")
   g = table.concat({g,g,g,g,g}, ",")
   
   -- parse groups
   loadstring("_G.grp = {" .. g .. "}")()

   print(line, g)
   LINES = LINES + 1
   print("LINES", LINES)
   
   -- Set up first attempt, all as much left as possible
   local instance = {}
   local x = line:find("[^%.]")
   local n
   for i,j in ipairs(grp) do
      table.insert(instance, {s=x, l=j})
--      print(x, j, line)
      n = line:sub(x+j+1):find("[^%.]")
      if n then
	 x = x + n + j
      end
   end
   print(inst_ts(instance))
   
   repeat
      local number = check(line, instance)
      if CHECKS % 1000000 == 0 then print("CHECKS", CHECKS) end
      CHECKS = CHECKS + 1
      --      if number == 1 then
      --      print(line)
      --      print(inst_ts(instance), number)
      --      end
      sum = sum + number
      --instance = false
      instance = step(line, instance)
   until not instance
   print(sum)
end

print(sum)
