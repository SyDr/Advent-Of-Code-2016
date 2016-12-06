local lpeg = require'lpeg'
local pp = require'pretty'

local data = {}
for line in io.lines("6.txt") do
  for i = 1, string.len(line) do
    if not data[i] then data[i] = {} end
    local sym = string.sub(line, i, i)
    if not data[i][sym] then data[i][sym] = 0 end
    data[i][sym] = data[i][sym] + 1
  end
end

for i, item in ipairs(data) do
  local sym
  for key, value in pairs(item) do
    --if not sym or item[key] > item[sym] then sym = key end -- part 1
    if not sym or item[key] < item[sym] then sym = key end
  end
  io.write(sym)
end

print()

