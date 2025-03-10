import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig(False)

c.content.user_stylesheets = ["/home/edwin/.config/qutebrowser/css/gruvbox.css"]

config.source('mappings.py')
config.source('colors.py')
config.source('blocklist.py')
config.source('websites.py')

# General
c.auto_save.session = False
c.downloads.location.directory = "/home/edwin/MathCareer/"
c.completion.shrink = True
c.completion.open_categories = ["quickmarks", "bookmarks", "searchengines"]
c.history_gap_interval = -1
c.messages.timeout = 2000
c.qt.args = [ "disable-logging", "enable-gpu-rasterization", "ignore-gpu-blocklist", "disable-features=FFmpegAllowLists" ]
c.qt.highdpi= True
c.session.lazy_restore = True
c.statusbar.padding = {"bottom": 0, "left": 0, "right": 0, "top": 0}
c.statusbar.show = "in-mode"

# Hints
c.hints.padding = {"bottom": 0, "left": 1, "right": 1, "top": 0}
c.hints.border = "2px solid"
c.hints.radius = 8
c.hints.scatter = False
c.hints.mode = "number"

# Colors
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.threshold.background = 110
c.colors.webpage.darkmode.threshold.foreground = 110

# Content
c.content.autoplay = False
c.content.notifications.enabled = False
c.content.geolocation               = False
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.fullscreen.window = True
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access-paste"
c.content.javascript.log_message.excludes = {"userscript:_qute_stylesheet": ["*Refused to apply inline style because it violates the following Content Security Policy directive: *"], 
                                             "userscript:_qute_js": ["*TrustedHTML*"]}
c.content.webgl = True

# Tabs
c.tabs.width = "14%"
c.tabs.position = "top"
c.tabs.show = "multiple"
c.tabs.title.alignment = "left"
c.tabs.title.elide = "right"
c.tabs.favicons.show = "always"
c.tabs.last_close = "default-page"
c.tabs.mousewheel_switching = False
c.tabs.new_position.unrelated = "next"
c.tabs.tooltips = False
c.tabs.wrap = False
c.tabs.padding = {"bottom": 2, "left": 5, "right": 5, "top": 2}

# Input
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False
c.input.insert_mode.leave_on_load = True

# Fonts
c.fonts.default_size = "15pt"
c.fonts.default_family = "Liberation Sans"
c.fonts.tabs.selected = "11pt bold"
c.fonts.tabs.unselected = "11pt default_family"
c.fonts.web.size.minimum = 14
c.fonts.web.size.default = 17
c.fonts.web.family.serif = "Liberation Serif"
