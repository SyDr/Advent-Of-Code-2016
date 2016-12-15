local lpeg = require'lpeg'
local pp = require'pretty'

local num = lpeg.R'09' ^ 1
local number = num / tonumber
local pattern = lpeg.Ct(lpeg.P("Disc #") * num * " has " * number * " positions; at time=0, it is at position " * number * ".")

local disc_list = {}
for line in io.lines("15.txt") do
  disc_list[#disc_list + 1] = lpeg.match(pattern, line)
end

local function solve(t, add)
  if add then t[#t + 1] = add end
  local current = 0
  
  while true do
    local valid = true
    
    for i, value in ipairs(t) do
      if ((current + i + value[2]) % value[1]) ~= 0 then
        valid = false
        break
      end
    end
    
    if valid then return current end
    
    current = current + 1
  end
end

print("1:", solve(disc_list))
print("2:", solve(disc_list, { 11, 0 }))
