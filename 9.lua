local lpeg = require'lpeg'
--local pp = require'pretty'

local number = lpeg.R'09' ^ 1 / tonumber
local marker = lpeg.Ct("(" * number * "x" * number * ")")
local letter = lpeg.R('AZ')
local data = lpeg.C((letter + marker) ^ 0)

local pattern = lpeg.C(letter) * data + marker * data

local function length_1(s)
  local action, data = lpeg.match(pattern, s)
  if type(action) == 'string' then
    return 1 + length_1(data)
  elseif action ~= nil then
    return action[2] * action[1] + length_1(string.sub(data, action[1] + 1))
  end
  
  return 0
end

local function length_2(s)
  local action, data = lpeg.match(pattern, s)
  if type(action) == 'string' then
    return 1 + length_2(data)
  elseif action ~= nil then
    return action[2] * length_2(string.sub(data, 1, action[1])) + length_2(string.sub(data, action[1] + 1))
  end
  
  return 0
end

local file_data = io.open("9.txt"):read("*a")
print(length_1(file_data))
print(length_2(file_data))
