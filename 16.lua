local pp = require'pretty'

local input = '10011111011011001'

local function dragon_curve(a)
  local t = {}
  for i = 1, string.len(a) do
      t[#t + 1] = string.sub(a, i, i)
  end
  
  t[#t + 1] = '0'
  
  for i = string.len(a), 1, -1 do
    t[#t + 1] = string.sub(a, i, i) == '0' and '1' or '0'
  end
  
  return table.concat(t)
end

local function checksum(s)
  if #s % 2 ~= 0 then return s end
  
  local t = {}
  for i = 1, string.len(s), 2 do
    t[#t + 1] = string.sub(s, i, i) == string.sub(s, i + 1, i + 1) and '1' or '0'
  end
  
  return checksum(table.concat(t))
end

local function solve(length)
  local input = input
  
  while #input < length do
    input = dragon_curve(input)
  end

  input = string.sub(input, 1, length)

  return checksum(input)
end

print("1:", solve(272))
print("2:", solve(35651584))
