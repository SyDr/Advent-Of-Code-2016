local lpeg = require'lpeg'
local pp = require'pretty'

local number = lpeg.R'09' ^ 1
local space = lpeg.P' ' ^ 1
local num_t = space * (number / tonumber) * (lpeg.P"T" + "%")

local pattern = "/dev/grid/node-" * lpeg.C("x" * number * "-y" * number) * num_t * num_t * num_t * num_t

local data = {}

for line in io.lines("22.txt") do
  local node, size, used, avail = lpeg.match(pattern, line)
  
  data[node] = { size, used, avail }
end

local total = 0
for a, a_v in pairs(data) do
  for b, b_v in pairs(data) do
    if a_v[2] > 0 and a ~= b and a_v[2] <= b_v[3] then total = total + 1 end
  end
end

print("1:", total)
print("2:", 3 + 17 + 31 + 5 * 35 + 1) -- solved by hand :(

for y = 0, 24 do
  for x = 0, 36 do
    local cm = true
    local current = "x" .. tostring(x) .. "-y" .. tostring(y)
    for _, v in ipairs({{-1, 0}, {1, 0}, {0, -1}, {0, 1}}) do
      local adj = "x" .. tostring(x + v[1]) .. "-y" .. tostring(y + v[2])
      --print(adj)
      if data[adj] and data[current][2] > 0 and data[current][2] > data[adj][1] then cm = false end
    end
    
    if data[current][2] == 0 then
      --io.write("_")
    elseif current == "x0-y0" then
      --io.write('G')
    elseif current == "x36-y0" then
      --io.write('P')
    elseif cm then 
      --io.write('.')
    else
      --io.write('#')
    end

  end
  --print()
end
