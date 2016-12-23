local lpeg = require'lpeg'
local pp = require'pretty'

local function to_op(cmd, op1, op2)
  local command = 3
  if cmd == "cpy" or cmd == "inc" then command = 1 end
  if cmd == "jnz" or cmd == "dec" then command = 2 end
  
  if cmd == "cpy" or cmd == "jnz" then
    return function(t)
      if t then
        if command == 1 then
          t[op2] = type(op1) == "string" and t[op1] or op1
        else
          if (type(op1) == "string" and t[op1] ~= 0) or (type(op1) == "number" and op1 ~= 0) then
            return type(op2) == "string" and t[op2] or op2
          else
            return 1
          end
        end
      else
        if command == 2 then command = 1 else command = 2 end
      end
      
      return 1
    end
  else
    return function(t)
      if t then
        if command == 1 then
          t[op1] = t[op1] + 1
        elseif command == 2 then
          t[op1] = t[op1] - 1
        else
          local val = type(op1) == "string" and t[op1] or op1
          if t.commands[t.current + val] then t.commands[t.current + val]() end
        end
      else
        if command == 1 then command = 2 else command = 1 end
      end
      
      return 1
    end
  end
end

local number = lpeg.C(lpeg.P"-" ^ -1 * lpeg.R'09' ^ 1) / tonumber
local command = lpeg.C(lpeg.P"cpy" + "inc" + "dec" + "jnz" + "tgl")
local space = lpeg.P(" ")
local register = lpeg.C(lpeg.S'abcd')
local target = number + register
local pattern = command * space * target * (space * target) ^ -1 / to_op

local commands1 = {}
local commands2 = {}
for line in io.lines("23.txt") do
  commands1[#commands1 + 1] = lpeg.match(pattern, line)
  commands2[#commands2 + 1] = lpeg.match(pattern, line)
end

local function solve(init, commands)
  local vm = init
  vm.commands = commands
  vm.current = 1
  
  while vm.commands[vm.current] do
    vm.current = vm.current + vm.commands[vm.current](vm)
  end
  
  return vm.a
end

print("1:", solve({a = 7, b = 0, c = 0, d = 0}, commands1))
print("2:", solve({a = 12, b = 0, c = 0, d = 0}, commands2))
