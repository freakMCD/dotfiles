import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

c.content.user_stylesheets = ["~/.config/qutebrowser/css/gruvbox-all-sites.css"]
config.source('mappings.py')
config.source('gruvbox.py')

c.content.autoplay = False
c.content.notifications.enabled = False
config.set('content.notifications.enabled', True, '*://web.whatsapp.com')

# Whitelist specific subdomain
config.set('content.blocking.whitelist', [
    '*://*.reddit.com/r/qutebrowser/*',
    '*://*.reddit.com/r/math/*',
    '*://*.reddit.com/r/AskPhysics/*',
    '*://*.reddit.com/r/linuxquestions/*',
    '*://*.reddit.com/r/hyprland/*',
    '*://*.reddit.com/r/bash/*',
    '*://*.reddit.com/r/archlinux/*',
    '*://*.reddit.com/r/youtubedl/*',
    '*://*.reddit.com/r/fossdroid/*',
])

config.set("input.mode_override", "passthrough", "https://onedrive.live.com/*")
config.set("content.javascript.can_open_tabs_automatically", True, "https://onedrive.live.com/*")
config.set("content.javascript.can_open_tabs_automatically", True, "https://www.microsoft365.com/*")

# Adblock
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt',
                                    'https://easylist.to/easylist/easyprivacy.txt',
                                    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt',
                                    'https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/pornography-hosts',
                                    ]

# Javascript
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access-paste"
config.set('content.javascript.enabled', False, 'wikipedia.org')
config.set('content.javascript.enabled', False, 'genius.com')

# General
c.colors.webpage.darkmode.enabled = True
c.fonts.default_size = "10pt"
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.completion.shrink = True
c.completion.open_categories = ["quickmarks", "bookmarks", "searchengines"]
c.content.fullscreen.window = True
c.content.webgl = False

# Tabs
c.session.lazy_restore = True
c.tabs.show = "multiple"
c.tabs.position = "top"
c.tabs.max_width = 200

c.url.searchengines = {
    "DEFAULT": "https://lite.duckduckgo.com/lite/?q={}",
    "yt": "https://invidious.privacyredirect.com/results?search_query={}",
}

c.qt.args = [ "enable-features=VaapiIgnoreDriverChecks",]

with config.pattern("*://discord.com/*") as p:
    p.content.media.audio_video_capture = True
    p.content.autoplay = True
