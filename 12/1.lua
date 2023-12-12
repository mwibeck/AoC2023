#!/usr/local/bin/lua-5.1
args = {...}


-- Line is like: ???.###  ? - unknown. . - empty # - spring
-- instance is {{s=starting pos, l=length of run}, ... }
-- Returns false if instance cannot fit in line
--         true  if instance is a possible solution
function check(line, instance)
  for idx,i in ipairs(instance) do
    for x=1,
    if line:
  end
  return true
end

for l in io.lines(args[1]) do
  local line,g = l:match("([%?%.%#]*) ([%d,]*)$")

  -- parse groups
  
end
