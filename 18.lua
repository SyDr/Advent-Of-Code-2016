local input = '.^^^.^.^^^^^..^^^..^..^..^^..^.^.^.^^.^^....^.^...^.^^.^^.^^..^^..^.^..^^^.^^...^...^^....^^.^^^^^^^'

local function next_tile(left, center, right)
  left = left and left or '.'
  right = right and right or '.'
  
  if left == '^' and center == '^' and right == '.' then return '^' end
  if left == '.' and center == '^' and right == '^' then return '^' end
  if left == '^' and center == '.' and right == '.' then return '^' end
  if left == '.' and center == '.' and right == '^' then return '^' end
  
  return '.'
end

local function solve(rows)
  local result = {}
  result[1] = {}

  for i = 1, string.len(input) do
    result[1][#result[1] + 1] = string.sub(input, i, i)
  end

  for i = 2, rows do
    result[i] = {}
    for j = 1, #result[i - 1] do
      result[i][j] = next_tile(result[i - 1][j - 1], result[i - 1][j], result[i - 1][j + 1])
    end
  end

  local total = 0
  for i = 1, #result do
    for j = 1, #result[i] do
      if result[i][j] == '.' then total = total + 1 end
    end
  end
  
  return total
end

print("1:", solve(40))
print("2:", solve(400000))
