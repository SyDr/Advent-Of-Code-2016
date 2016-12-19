local pp = require'pretty'
local input = 3014387

local function f(n)
  if n == 1 then
    return 1
  elseif n % 2 == 0 then
    return f(n / 2) * 2 - 1
  else
    return f((n - 1) / 2) * 2 + 1
  end
end

local numbers = {}
for i = 1, input do
  numbers[i] = i ~= input and i + 1 or 1
end

local current = math.floor(input / 2) + 1
local prev = current - 1
local skip = input % 2 ~= 0 and true or false

while numbers[current] ~= numbers[numbers[current]] do
  numbers[prev] = numbers[current]
  current, numbers[current] = numbers[current], nil

  if skip then
    prev, current = numbers[prev], numbers[numbers[prev]]
  end
  
  skip = not skip
end

print("1:", f(input))
print("2:", numbers[current])
