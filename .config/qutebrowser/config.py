import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

c.content.user_stylesheets = ["~/.config/qutebrowser/css/gruvbox-all-sites.css"]

config.source('mappings.py')
config.source('gruvbox.py')

# Adblock
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt',
                                    'https://easylist.to/easylist/easyprivacy.txt',
                                    'https://easylist.to/easylist/fanboy-social.txt',
                                    'https://secure.fanboy.co.nz/fanboy-annoyance.txt',
                                    'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt',
                                    'https://www.i-dont-care-about-cookies.eu/abp/',
                                    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt']
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access-paste"
c.colors.webpage.darkmode.enabled = True
c.fonts.default_size = "10pt"
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.completion.shrink = True
c.completion.open_categories = ["quickmarks", "bookmarks", "searchengines"]

# Prevents *all* tabs from being loaded on restore, only loads on activating them
c.session.lazy_restore = True
c.tabs.show = "always"

c.qt.args += [  'ignore-gpu-blocklist',
                'autoplay-policy=user-gesture-require',
              'enable-features=VaapiIgnoreDriverChecks', 
             ]
c.url.searchengines = {
    "DEFAULT": "https://lite.duckduckgo.com/lite/?q={}",
    "yt": "farside.link/piped/results?search_query={}",
}

