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
c.qt.chromium.process_model = "process-per-site"
c.qt.args=["ignore-gpu-blocklist","enable-zero-copy","enable-features=VaapiIgnoreDriverChecks"]
c.auto_save.session = False
c.downloads.location.directory = "/home/edwin/Downloads/"
c.downloads.location.prompt = True
c.downloads.remove_finished = 300000
c.downloads.open_dispatcher = "xdg-open {}"
c.completion.height = "25%"
c.completion.scrollbar.padding = 2
c.completion.shrink = True
c.completion.open_categories = ["quickmarks", "bookmarks", "searchengines"]
c.history_gap_interval = -1
c.messages.timeout = 2000
c.session.lazy_restore = True
c.statusbar.padding = {"bottom": 0, "left": 0, "right": 0, "top": 0}
c.statusbar.show = "in-mode"

# Hints
c.hints.padding = {"bottom": 0, "left": 1, "right": 1, "top": 0}
c.hints.border = "2px solid"
c.hints.radius = 8
c.hints.scatter = False
c.hints.mode = "letter"
c.hints.chars = "qwerasdzxc"

# Colors
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.threshold.background = 110
c.colors.webpage.darkmode.threshold.foreground = 110

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
c.input.forward_unbound_keys = "none"

# Fonts
c.fonts.contextmenu = "default_size default_family"
c.fonts.default_family = "LiterationSans Nerd Font"
c.fonts.default_size = "11pt"
c.fonts.prompts = "default_size default_family"
c.fonts.tooltip = "default_size default_family"
c.fonts.web.family.cursive = "default_family"
c.fonts.web.family.fantasy = "default_family"
c.fonts.web.family.fixed = "default_family"
c.fonts.web.family.sans_serif = "default_family"
c.fonts.web.family.serif = "default_family"
c.fonts.web.family.standard = "default_family"
c.fonts.web.size.default = 16
c.fonts.web.size.default_fixed = 16
c.fonts.web.size.minimum = 16
c.fonts.web.size.minimum_logical = 16

