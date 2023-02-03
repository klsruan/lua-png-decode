local ffi = require "ffi"
local lodepng = ffi.load "binaries/liblodepng.dll"
local blitbuffer = require("blitbuffer/blitbuffer")
local png = {}

ffi.cdef [[
    typedef enum {
        LCT_GREY = 0,
        LCT_RGB = 2,
        LCT_PALETTE = 3,
        LCT_GREY_ALPHA = 4,
        LCT_RGBA = 6,
    } LodePNGColorType;
    const char *LODEPNG_VERSION_STRING;
    const char *lodepng_error_text(unsigned int);
    unsigned int lodepng_decode32_file(unsigned char **, unsigned int *, unsigned int *, const char *);
]]

png.version = function()
    return ffi.string(lodepng.LODEPNG_VERSION_STRING)
end

png.decode = function(filename)
    local rawData = ffi.new "unsigned char*[1]"
    local width = ffi.new "int[1]"
    local height = ffi.new "int[1]"

    local err = lodepng.lodepng_decode32_file(rawData, width, height, filename)
    assert(err == 0, ffi.string(lodepng.lodepng_error_text(err)))

    local buffer = blitbuffer(width[0], height[0], 5, rawData[0])
    buffer:set_allocated(1)

    png.rawData = buffer
    png.width = buffer:get_width()
    png.height = buffer:get_height()
    png.bit_depth = buffer:get_bpp()
    png.length = png.width * png.height

    png.getPixel = function(x, y)
        return buffer:get_pixel(x, y):get_color_32()
    end

    png.getData = function()
        png.data = ffi.new("color_RGBA[?]", png.length)
        for y = 0, png.height - 1 do
            for x = 0, png.width - 1 do
                local i = y * png.width + x
                local pixel = png.getPixel(x, y)
                png.data[i].r = pixel.r
                png.data[i].g = pixel.g
                png.data[i].b = pixel.b
                png.data[i].a = pixel.alpha
            end
        end
    end

    return png
end

return png