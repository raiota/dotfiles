local status, colorizer = pcall(require, "nvim-colorizer")
if (not status) then return end

nvim_colorizer.setup()
