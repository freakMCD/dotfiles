import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

c.content.user_stylesheets = ["~/.config/qutebrowser/css/gruvbox-all-sites.css"]
config.source('mappings.py')
config.source('gruvbox.py')

c.content.autoplay = False

# Adblock
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt',
                                    'https://easylist.to/easylist/easyprivacy.txt',
                                    'https://easylist.to/easylist/fanboy-social.txt',
                                    'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt',
                                    'https://raw.githubusercontent.com/arapurayil/aBL/main/filters/nsfw.txt',
                                    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt',
                                    'https://secure.fanboy.co.nz/fanboy-annoyance.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt',]

# General
c.content.javascript.enabled = False
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
    "yt": "https://inv.n8pjl.ca/results?search_query={}",
}

with config.pattern("*://discord.com/*") as p:
    p.content.media.audio_video_capture = True
    p.content.autoplay = True
