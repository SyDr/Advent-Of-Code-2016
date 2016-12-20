local lpeg = require'lpeg'

local number = lpeg.R'09' ^ 1 / tonumber
local pattern = number * "-" * number

local list = {}
for line in io.lines("20.txt") do
  list[#list + 1] = { lpeg.match(pattern, line) }
end

local i = 0
local first
local total = 0

while i <= 4294967295 do
  local blocked = false
  for _, value in ipairs(list) do
    if i >= value[1] and i <= value[2] then
      blocked = true
      i = value[2]
      break
    end
  end
  
  if not blocked then
    if not first then first = i end
    total = total + 1
  end
  
  i = i + 1
end

print("1:", first)
print("2:", total)
