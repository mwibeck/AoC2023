#!/usr/local/bin/lua-5.1
args = {...}

local hzP = {}
local lastHz = nil
local hzCandidates = {}

local sum = 0

function findMirror(cands, pattern)
--   print("Find mirror", #cands)
   for i,j in ipairs(cands) do
      local offs = 1
      local broke = false
      while (1 <= j-offs-1) and (j + offs <= #pattern) do
--	 print("compare", j-offs-1, j+offs)
	 if pattern[j-offs-1] ~= pattern[j+offs] then
	    -- Not it
	    broke = true
	    break
	 end
	 offs = offs + 1
      end
      if not broke then
	 return j-1
      end
   end
   return 0
end

for l in io.lines(args[1]) do

   if #l == 0 then
      -- End of pattern. Check it.

      row = findMirror(hzCandidates, hzP)
      sum = sum + 100 * row
      print("Horiz mirror", row)

      if row == 0 then
	 -- Not a horizontal mirror.
	 -- Transpose, and test vertical mirroring
	 local vtP = {}
	 local vtCandidates = {}
	 local lastVt
	 
	 for x=1,#hzP[1] do
	    for _,y in ipairs(hzP) do
	       vtP[x] = (vtP[x] or "") .. y:sub(x,x)
	    end

	    if lastVt == vtP[x] then
	       table.insert(vtCandidates, #vtP)
	    end
	    lastVt = vtP[x]
	 end

	 row = findMirror(vtCandidates, vtP)
	 sum = sum + row
	 print("Vertical mirror", row)
      end
      
      hzP = {}
      hzCandidates = {}
      lastHz = nil
   else
      table.insert(hzP, l)
      
      if lastHz == l then
	 table.insert(hzCandidates, #hzP)
      end

      lastHz = l
   end   
end
-- last patternL
row = findMirror(hzCandidates, hzP)
sum = sum + 100 * row
print("Horiz mirror", row)

if row == 0 then
   -- Not a horizontal mirror.
   -- Transpose, and test vertical mirroring
   
   local vtP = {}
   local vtCandidates = {}
   local lastVt
   
   for x=1,#hzP[1] do
      for _,y in ipairs(hzP) do
	 vtP[x] = (vtP[x] or "") .. y:sub(x,x)
      end
      
      if lastVt == vtP[x] then
	 table.insert(vtCandidates, #vtP)
      end
      lastVt = vtP[x]
   end
   
   row = findMirror(vtCandidates, vtP)
   print("Vertical mirror", row)
   sum = sum + row
end

print(sum)
