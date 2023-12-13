#!/usr/local/bin/lua-5.1
args = {...}


-- Line is like: ???.###  ? - unknown. . - empty # - spring
-- instance is {{s=starting pos, l=length of run}, ... }
-- Returns 0 if instance cannot fit in line
--         1 if instance is a possible solution
function check(line, instance)
   local last = 1
   for idx,i in ipairs(instance) do

      -- check for # before this run
      if line:sub(last, i.s-1):match("%#") then
	 return 0
      end

      -- no .'s in run.
      if line:sub(i.s, i.s + i.l - 1):match("%.") then
	 return 0
      end
      last = i.s + i.l
   end

   -- No # after last 'run'
   if line:sub(last):match("%#") then
      return 0
   end
   
   return 1
end

function inst_ts(instance)
   local s = string.rep(".",instance[1].s-1)
   for i=1,#instance do
      s = s .. string.rep("#",instance[i].l)
      if i < #instance then
	 s = s .. string.rep(".", instance[i+1].s - #s - 1)
      end
   end
   return s
end

function step(len, instance)
   local i = #instance
   local inst = instance
   local used_len = inst[i].l
   local x = false
   
   repeat
--      print("used", used_len, i, inst[i].s, len)
      if used_len + inst[i].s-1 < len then
	 inst[i].s = inst[i].s+1
	 if i+1 <= #instance then
	    for x = i+1,#instance,1 do
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

for l in io.lines(args[1]) do
   local line,g = l:match("([%?%.%#]*) ([%d,]*)$")

   -- parse groups
   loadstring("_G.grp = {" .. g .. "}")()

   print(line, g)
   
   -- Set up first attempt, all to the "left", one step inbetween
   local instance = {}
   local x = 1
   for i,j in ipairs(grp) do
      table.insert(instance, {s=x, l=j})
--      print(x, j)
      x = x + j + 1
   end
   
   local number = 0
   repeat
      number = check(line, instance)
      print(inst_ts(instance), number)
      sum = sum + number
      --instance = false
      instance = step(#line, instance)
   until not instance
end

print(sum)
