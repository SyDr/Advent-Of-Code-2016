local lpeg = require'lpeg'
local pp = require'pretty'

local function find(t, v) for i, item in ipairs(t) do if item == v then return i end end end
local function to_string(t) return table.concat(t) end

local function to_table(s)
  local t = {}
  for i = 1, #s do t[i] = string.sub(s, i, i) end
  return t
end

local function rotate(n)
  return function(t)
    local s = to_string(t)
    
    if n > 0 then
      s = string.sub(string.rep(s, 2), string.len(s) + 1 - n, 2 * string.len(s) - n)
    elseif n < 0 then
      s = string.sub(string.rep(s, 2), -n + 1, string.len(s) - n)
    end
    
    return to_table(s)
  end
end

local positional_back_rotate = { -1, -1, 2, -2, 1, -3, 0, -4 }

local function rotate_by_pos(value, back)
  return function(t)
    local pos = find(t, value)
    local times = (pos + (pos > 4 and 1 or 0)) % #t 

    if back then
      return rotate(positional_back_rotate[pos])(t)
    else
      return rotate(times)(t)
    end
  end
end

local function swap(x, y)
  return function(t)
    t[x], t[y] = t[y], t[x]
    return t
  end
end

local function move(x, y)
  return function(t)
    table.insert(t, y + 1, table.remove(t, x + 1))
    return t
  end
end

local function to_op(op, x, y)
  if op == "swap" then
    if type(x) == 'number' then
      return { swap(x + 1, y + 1), swap(y + 1, x + 1) }
    else
      return { function(t) return swap(find(t, x), find(t, y))(t) end, function(t) return swap(find(t, y), find(t, x))(t) end }
    end
  elseif op == "rotate" then
    if x == "left" or x == "right" then
      local n = x == "right" and y or -y
      
      return { rotate(n), rotate(-n) }
    else
      return { rotate_by_pos(x), rotate_by_pos(x, true) }
    end
  elseif op == "reverse" then
    local function f(t)
      for i = x + 1, x + math.floor((y - x) / 2) + 1  do
        t[i], t[y - i + x + 2] = t[y - i + x + 2], t[i]
      end
      return t
    end
    return { f, f }
  elseif op == "move" then
    return { move(x, y), move(y, x) }
  end
end

local number = lpeg.R'09' ^ 1 / tonumber
local letter = lpeg.C(lpeg.R'az')
local swap_pos = lpeg.C"swap" * " position " * number * " with position " * number
local swap_let = lpeg.C"swap" * " letter " * letter * " with letter " * letter
local rotate_num = lpeg.C"rotate" * " " * lpeg.C(lpeg.P"left" + "right") * " " * number * " step" * lpeg.P"s" ^ -1
local rotate_pos = lpeg.C"rotate" * " based on position of letter " * letter
local reverse = lpeg.C"reverse" * " positions " * number * " through " * number
local move_pat = lpeg.C"move" * " position " * number * " to position " * number

local pattern = (swap_pos + swap_let + rotate_num + rotate_pos + reverse + move_pat) / to_op

local input = to_table'abcdefgh'
local scrambled = to_table'fbgdceah'

local op_list = {}
for line in io.lines("21.txt") do
  op_list[#op_list + 1] = lpeg.match(pattern, line)
end

for i = 1, #op_list do
  input = op_list[i][1](input)
end

for i = #op_list, 1, -1 do
  scrambled = op_list[i][2](scrambled)
end

print("1:", to_string(input))
print("2:", to_string(scrambled))
