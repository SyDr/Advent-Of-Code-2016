local lpeg = require'lpeg'
--local pp = require'pretty'

local number = lpeg.R'09' ^ 1 / tonumber
local input = "value " * number * " goes to bot " * number
local target = lpeg.C(lpeg.P"bot" + "output")
local output = "bot " * number * " gives low to " * target * " " * number * " and high to " * target * " " * number

local pattern = lpeg.Ct(input + output)

local commands = {}
for line in io.lines("10.txt") do
  commands[#commands + 1] = lpeg.match(pattern, line)
end

local function add_value(t, v)
  local r = t
  
  if not r then r = {} end
  if not r[1] then r[1] = v else r[2] = v end
  
  return r
end

local i = 1
local data = {}
local output = {}

while #commands > 0 do
  if i > #commands then i = 1 end
  
  local num, t1, n1, t2, n2 = table.unpack(commands[i])
  local can_execute = true
  
  if not n1 then
    if data[t1] and data[t1][2] then can_execute = false end
  else
    if (not data[num] or not data[num][1] or not data[num][2]) or 
       (t1 == "bot" and data[n1] and data[n1][2]) or
       (t2 == "bot" and data[n2] and data[n2][2]) then
      can_execute = false
    end
  end
  
  if not can_execute then
    i = i + 1
  elseif not n1 then
    data[t1] = add_value(data[t1], num)
    table.remove(commands, i)
  else
    local min = math.min(data[num][1], data[num][2])
    local max = math.max(data[num][1], data[num][2])
    
    if min == 17 and max == 61 then print("1:", num) end
    
    if t1 == "bot" then data[n1] = add_value(data[n1], min) else output[n1] = min end
    if t2 == "bot" then data[n2] = add_value(data[n2], max) else output[n2] = max end
    
    data[num] = nil
    table.remove(commands, i) -- 40 mins before: table.remove(commands, 1) 
  end
end

print("2:", output[0] * output[1] * output[2])
