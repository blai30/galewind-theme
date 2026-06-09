-- Lua sample for syntax highlighting
local M = {}

local DEFAULTS = {
  accent = "#38BDF8",
  retries = 3,
  enabled = true,
}

--[[
  Vector2 implements basic 2D vector math using a metatable
  so instances support the + operator and tostring().
]]
local Vector2 = {}
Vector2.__index = Vector2

function Vector2.new(x, y)
  return setmetatable({ x = x or 0, y = y or 0 }, Vector2)
end

function Vector2.__add(a, b)
  return Vector2.new(a.x + b.x, a.y + b.y)
end

function Vector2:magnitude()
  return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

function Vector2.__tostring(self)
  return string.format("(%.2f, %.2f)", self.x, self.y)
end

function M.configure(options)
  options = options or {}
  local config = {}
  for key, value in pairs(DEFAULTS) do
    config[key] = options[key] ~= nil and options[key] or value
  end
  return config
end

function M.demo()
  local sum = Vector2.new(3, 4) + Vector2.new(1, 2)
  print(tostring(sum), sum:magnitude())

  local names = { "rose", "sky" }
  for index, name in ipairs(names) do
    print(index, name:upper())
  end
end

return M
