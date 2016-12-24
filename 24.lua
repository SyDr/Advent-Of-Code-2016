local lpeg = require'lpeg'
local pp = require'pretty'

local data = {}

local current = 1
local start
local numbers = {}

for line in io.lines("24.txt") do
  data[current] = {}
  for i = 1, #line do
    data[current][i] = string.sub(line, i, i)
    if tonumber(data[current][i]) then data[current][i] = tonumber(data[current][i]) end
    if data[current][i] == 0 then start = { current, i } end
    if type(data[current][i]) == "number" then numbers[data[current][i]] = true end
  end
  current = current + 1
end

local function to_string(t)
  local s = ''
  for i = 0, 7 do if t[i] then s = s .. tostring(i) end end
  return s
end

local function to_table(s)
  local t = {}
  for i = 1, #s do t[tonumber(string.sub(s, i, i))] = true end
  return t
end

local function new_key(s, n)
  local t = to_table(s)
  if type(n) == "number" then t[n] = true end
  local res = to_string(t)
  if res == '01234567' and n == 0 then res = '012345670' end
  return res
end

local sol = { ["0" .. "s" .. tostring(start[1]) .. "x" .. tostring(start[2])] = true }
local queue = { ["0" .. "s" .. tostring(start[1]) .. "x" .. tostring(start[2])] = { start, "0", 0 } }

local solved, solved2

while not solved or not solved2 do
  local keys = {}
  for _, val in pairs(queue) do
    keys[#keys + 1] = val
  end
  
  for _, val in ipairs(keys) do
    local cur_x, cur_y = val[1][1], val[1][2]
    local steps = val[3]
    local key = val[2]
    
    sol[key .. "s" .. tostring(cur_x) .. "x" .. tostring(cur_y)] = true
    queue[key .. "s" .. tostring(cur_x) .. "x" .. tostring(cur_y)] = nil
    
    for _, i in ipairs({ {-1, 0}, {1, 0}, {0, -1}, {0, 1} }) do
      local x, y = cur_x + i[1], cur_y + i[2]

      if data[x] and data[x][y] and data[x][y] ~= '#' then
        local s_key = new_key(key, data[x][y])

        if s_key == "01234567" and not solved then solved = steps + 1 break end
        if s_key == "012345670" and not solved2 then solved2 = steps + 1 break end
        
        local new_key = s_key .. "s" .. tostring(x) .. "x" .. tostring(y)
        if not sol[new_key] then queue[new_key] = { {x, y}, s_key, steps + 1 } end
      end
    end
  end
end

print("1:", solved)
print("2:", solved2)
