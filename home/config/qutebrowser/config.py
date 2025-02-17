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
c.completion.shrink = True
c.completion.open_categories = ["quickmarks", "bookmarks", "searchengines"]
c.messages.timeout = 2000
c.qt.args = [ "disable-logging", "enable-gpu-rasterization", "ignore-gpu-blocklist", "disable-features=FFmpegAllowLists" ]
c.session.lazy_restore = True
c.statusbar.padding = {"bottom": 0, "left": 0, "right": 0, "top": 0}
c.statusbar.show = "in-mode"

# Colors
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.threshold.background = 110
c.colors.webpage.darkmode.threshold.foreground = 110

# Content
c.content.autoplay = False
c.content.notifications.enabled = False
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.fullscreen.window = True
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access-paste"
c.content.javascript.log_message.excludes = {"userscript:_qute_stylesheet": ["*Refused to apply inline style because it violates the following Content Security Policy directive: *"], 
                                             "userscript:_qute_js": ["*TrustedHTML*"]}
c.content.webgl = True

# Tabs
c.tabs.width = "12%"
c.tabs.position = "right"
c.tabs.show = "multiple"
c.tabs.title.alignment = "left"
c.tabs.title.elide = "none"
c.tabs.favicons.show = "never"
c.tabs.last_close = "default-page"
c.tabs.mousewheel_switching = False
c.tabs.new_position.unrelated = "next"
c.tabs.tooltips = False
c.tabs.wrap = False

# Input
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False
c.input.insert_mode.leave_on_load = True

# Fonts
c.fonts.default_size = "11pt"
c.fonts.default_family = "Liberation Sans"
c.fonts.tabs.selected = "10pt bold"
c.fonts.tabs.unselected = "10pt default_family"
c.fonts.web.size.minimum = 14
c.fonts.web.size.default = 17
