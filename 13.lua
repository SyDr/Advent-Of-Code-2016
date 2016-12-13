local function is_open_space(x, y)
  local num = x * x + 3 * x + 2 * x * y + y + y * y + 1352
  local result = 0
  
  while num > 0 do
    result, num = result + num % 2, math.floor(num / 2)
  end
  
  return result % 2 == 0
end

local data = { ["1x1"] = 0 }
local queue = { {1, 1}, current = 1, max = 1 }

local total = 1
while queue.current <= queue.max or not data["31x39"] do
  local cur_x, cur_y = queue[queue.current][1], queue[queue.current][2]
  local steps = data[cur_x .. "x" .. cur_y]

  for _, i in ipairs({ {-1, 0}, {1, 0}, {0, -1}, {0, 1} }) do
    local x = cur_x + i[1]
    local y = cur_y + i[2]
    
    if x >= 0 and y >= 0 and not data[x .. "x" .. y] and is_open_space(x, y) then
      data[x .. "x" .. y] = steps + 1
      queue[queue.max + 1] = {x, y}
      queue.max = queue.max + 1
      if steps < 50 then total = total + 1 end
    end
  end

  queue.current = queue.current + 1
end

print("1:", data["31x39"])
print("2:", total)
