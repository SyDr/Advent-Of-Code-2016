local lpeg = require'lpeg'
local pp = require'pretty'

local rows = 6
local columns = 50

local number = lpeg.C(lpeg.R'09' ^ 1) / tonumber

local rect = lpeg.C("rect") * " " * number * "x" * number
local r_row = "rotate " * lpeg.C("row") * " y=" * number * " by " * number
local r_columnn = "rotate " * lpeg.C("column") * " x=" * number * " by " * number

local pattern = rect + r_row + r_columnn

local function turn_on(data, a, b)
  for i = 0, a - 1 do
    for j = 0, b - 1 do
      data[i][j] = '#'
    end
  end
end

local function rotate_row(data, row, num)
  for i = 1, num do
    local temp = data[columns - 1][row]
    for j = columns - 2, 0, -1 do
      data[j + 1][row] = data[j][row]
    end
    data[0][row] = temp
  end
end

local function rotate_column(data, column, num)
  for i = 1, num do
    local temp = data[column][rows - 1]
    for j = rows - 2, 0, -1 do
      data[column][j + 1] = data[column][j]
    end
    data[column][0] = temp
  end
end

local data = {}
for i = 0, columns - 1 do
  data[i] = {}
  for j = 0, rows - 1 do
    data[i][j] = '.'
  end
end

for line in io.lines("8.txt") do
  local command, i1, i2 = lpeg.match(pattern, line)
  if command == "rect" then
    turn_on(data, i1, i2)
  elseif command == "row" then
    rotate_row(data, i1, i2)
  else
    rotate_column(data, i1, i2)
  end
end

local total = 0
for i = 0, rows - 1 do
  for j = 0, columns - 1 do
    if data[j][i] == '#' then total = total + 1 end
    io.write(data[j][i])
  end
  print()
end

print(total)
