# Subpixel hinting mode can be chosen by setting the right TrueType interpreter
# version. The available settings are:
#
#     truetype:interpreter-version=35  # Classic mode (default in 2.6)
#     truetype:interpreter-version=40  # Minimal mode (default in 2.7)
#
# There are more properties that can be set, separated by whitespace. Please
# refer to the FreeType documentation for details.

# Uncomment and configure below
# https://wiki.archlinux.org/title/Font_configuration#Text_is_blurry
set -Ux FREETYPE_PROPERTIES "truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"
