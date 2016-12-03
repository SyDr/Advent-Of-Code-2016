local lpeg = require'lpeg'
--local pp = require'pretty'

local number = lpeg.R'09' ^ 1 / tonumber
local space = lpeg.P(" ") ^ 0
local pattern = space * number * space * number * space * number

local total = 0
local i = 0
local triangles = {}

for line in io.lines("3.txt") do
  i = i + 1
  local a, b, c = lpeg.match(pattern, line)
  triangles[i] = { a, b, c }
end

for i = 1, #triangles, 3 do
  for j = 1, 3 do
    local a, b, c = triangles[i][j], triangles[i+1][j], triangles[i+2][j]
    if a + b > c and a + c > b and b + c > a then
      total = total + 1
    end
  end
end

print(total)
