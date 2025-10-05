-- Return memory as a number only (no unit)
function conky_strip(value)
    local mem = conky_parse(value)  -- e.g. "11.345G"
    local num = string.match(mem, "([%d%.]+)")
    if num then
        return string.format("%.1f", tonumber(num))
    end
    return mem
end

