# install.packages("hexSticker")

library(hexSticker)
library(magick)

logo <- image_read("man/figures/IDDO-logo-transparent-background.png")

iddoverse_hexsticker_border <- sticker(
  logo,
  package = "iddoverse",
  s_x = 1,
  s_y = 0.8,
  s_width = 0.4 * 3.250871,
  s_height = 0.4,
  p_x = 1,
  p_y = 1.3,
  p_size = 14,
  p_family = "sans",
  p_fontface = "bold",
  p_color = "#14B1e7",
  h_size = 3.5,
  h_fill = "white",
  h_color = "#14B1e7"
)
plot(iddoverse_hexsticker_border)

iddoverse_with_border = iddoverse_hexsticker +
  geom_hexagon(size = 1.2,
               fill = NA,
               color = "white")

iddoverse_with_border

save_sticker("man/figures/iddoverse_hexsticker.png", sticker = iddoverse_with_border)

#----------- solid border ------------------------------------------------------
iddoverse_hexsticker <- sticker(
  logo,
  package = "iddoverse",
  s_x = 1,
  s_y = 0.8,
  s_width = 0.4 * 3.250871,
  s_height = 0.4,
  p_x = 1,
  p_y = 1.3,
  p_size = 16,
  p_family = "sans",
  p_fontface = "bold",
  p_color = "#14B1e7",
  h_size = 1.2,
  h_fill = "white",
  h_color = "#14B1e7"
)
plot(iddoverse_hexsticker)

save_sticker("man/figures/iddoverse_hexsticker_solid.png", sticker = iddoverse_hexsticker)
#-------------------------------------------------------------------------------
