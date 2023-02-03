local lodepng = require "lodepng"

local png = lodepng.decode("images/1.png")
png.getData()

for i = 0, png.length - 1 do
    local pixel = png.data[i]
    print("r: " .. pixel.r, "g: " .. pixel.g, "b: " .. pixel.b, "a: " .. pixel.a)
end