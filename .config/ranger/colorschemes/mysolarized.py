from ranger.colorschemes.solarized import Solarized
from ranger.gui.color import (
    cyan, magenta, red, white, default,
    normal, bold, reverse,
    default_colors,
)

class Scheme(Solarized):
    def use(self, context):
        fg, bg, attr = Solarized.use(self, context)
        if context.in_titlebar:
            if context.tab:
                bg = default if context.bad else 33
            elif context.hostname:
                fg = 16
#         elif context.in_browser:
#             if context.border:
#                 fg = 93

        return fg, bg, attr
