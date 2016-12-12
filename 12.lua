local lpeg = require'lpeg'
--local pp = require'pretty'

local function to_command(cmd, op1, op2)
  if cmd == "cpy" and type(op1) == "number" then
    return function(state) state[op2] = op1 return 1 end
  elseif cmd == "cpy" and type(op1) ~= "number" then
    return function(state) state[op2] = state[op1] return 1 end
  elseif cmd == "inc" then
    return function(state) state[op1] = state[op1] + 1 return 1 end
  elseif cmd == "dec" then
    return function(state) state[op1] = state[op1] - 1 return 1 end
  elseif cmd == "jnz" then
    return function(state) if state[op1] ~= 0 then return op2 else return 1 end end
  end
end

local number = lpeg.C(lpeg.P"-" ^ -1 * lpeg.R'09' ^ 1) / tonumber
local command = lpeg.C(lpeg.P"cpy" + "inc" + "dec" + "jnz")
local space = lpeg.P(" ")
local register = lpeg.C(lpeg.S'abcd' ^ 1)

local pattern = command * space * (number + register) * (space * (number + register)) ^ -1 / to_command

local commands = {}
for line in io.lines("12.txt") do
  commands[#commands + 1] = lpeg.match(pattern, line)
end

local function solve(init)
  local vm = init
  local current = 1
  
  while commands[current] do
    current = current + commands[current](vm)
  end
  
  return vm.a
end

print("1:", solve({a = 0, b = 0, c = 0, d = 0}))
print("2:", solve({a = 0, b = 0, c = 1, d = 0}))
