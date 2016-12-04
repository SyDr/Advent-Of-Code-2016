local lpeg = require'lpeg'
local pp = require'pretty'

local number = lpeg.R'09' ^ 1
local group = lpeg.R'az' ^ 1
local space = lpeg.S("-")
local checksum = lpeg.P("[") * lpeg.C(group) * lpeg.P("]")
local pattern = lpeg.Ct((lpeg.C(group) * space) ^ 1) * lpeg.C(number) * checksum
local pattern2 = lpeg.C((group * space) ^ 1) * number * checksum

local function split(data)
  local result = {}
  for i, item in ipairs(data) do
    for k = 1, #item do
      local letter = string.sub(item, k, k)
      result[letter] = result[letter] and result[letter] + 1 or 1
    end
  end
  
  return result
end

local function consume(data, letter)
  local max = -1
  local maxL = nil;
  
  for i, item in pairs(data) do
    if item > max or (item == max and letter < maxL) then
      max = item
      maxL = i
    end
  end
    
  if letter == maxL then
    data[letter] = nil
  end
      
  return data, maxL == letter
end

local function isReal(data, checksum)
  local splitted = split(data)
  local valid = true
  for i = 1, string.len(checksum) do
    splitted, valid = consume(splitted, string.sub(checksum, i, i))
    if not valid then break end
  end
  
  return valid
end

local function rotate(s, num)
  local result = ''
  for i = 1, string.len(s) do
    local l = string.sub(s, i, i)
    if l == '-' then
      l = ' '
    else
      l =  string.char((l:byte() - string.byte('a') + num) % 26 + string.byte('a'))
    end
    
    result = result .. l
  end
  
  return result
end

local total = 0
for line in io.lines("4.txt") do
  local data, num, check = lpeg.match(pattern, line)
  if isReal(data, check) then
    total = total + num
    local name = rotate(lpeg.match(pattern2, line), num)
    if string.sub(name, 1, 2) == "no" then
      print(name, num)
    end
  end
end

print(total)

