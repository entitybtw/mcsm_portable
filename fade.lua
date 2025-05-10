local fade_speed = 5
local fade_in = 255
local fade_out = 0

local function fadeImage(image, x, y, w, h, color, duration, fadeTo, srcx, srcy, srcw, srch, r, a, alMode)
    local alpha = (fadeTo == fade_in) and 0 or 255
    local step = (fadeTo == fade_in) and fade_speed or -fade_speed

    while (fadeTo == fade_in and alpha < 255) or (fadeTo == fade_out and alpha > 0) do
        alpha = alpha + step
        screen.clear()
        Image.draw(image, x, y, w, h, color, srcx, srcy, srcw, srch, r, alpha, alMode)
        screen.flip()
        LUA.sleep(duration / 255)
    end
end

return {
    fadeIn = function(image, x, y, w, h, color, duration, srcx, srcy, srcw, srch, r, a, alMode)
        fadeImage(image, x, y, w, h, color, duration, fade_in, srcx, srcy, srcw, srch, r, a, alMode)
    end,
    fadeOut = function(image, x, y, w, h, color, duration, srcx, srcy, srcw, srch, r, a, alMode)
        fadeImage(image, x, y, w, h, color, duration, fade_out, srcx, srcy, srcw, srch, r, a, alMode)
    end
}
