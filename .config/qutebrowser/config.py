import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig(False)

c.content.user_stylesheets = ["/home/edwin/.config/qutebrowser/css/gruvbox-all-sites.css"]
config.source('mappings.py')
config.source('gruvbox.py')
config.source('blocklist.py')
config.source('websites.py')
# General
c.auto_save.session = False
c.downloads.location.directory = "/home/edwin/MathCareer/"
c.fonts.default_size = "10pt"
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.completion.shrink = True
c.completion.open_categories = ["quickmarks", "bookmarks", "searchengines"]
c.messages.timeout = 2000
c.qt.args = [ "enable-features=VaapiIgnoreDriverChecks",]
c.session.lazy_restore = True
c.statusbar.padding = {"bottom": 0, "left": 0, "right": 0, "top": 0}
c.tabs.show = "never"
c.statusbar.show = "in-mode"


# Colors
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "never"

# Content
c.content.autoplay = False
c.content.notifications.enabled = False
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.fullscreen.window = True
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access-paste"
c.content.webgl = True

