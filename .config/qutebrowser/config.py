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
    '*://*.reddit.com/r/Handwriting/*',
    '*://*.reddit.com/r/math/*',
])

# Adblock
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt',
                                    'https://easylist.to/easylist/easyprivacy.txt',
                                    'https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/pornography-hosts',
                                    ]

# General
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access-paste"
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

with config.pattern("*://discord.com/*") as p:
    p.content.media.audio_video_capture = True
    p.content.autoplay = True
