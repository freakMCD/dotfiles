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

# Define keywords and subdomains
keywords = ['qutebrowser', 'math', 'AskPhysics', 'linuxquestions', 'hyprland', 'bash', 'archlinux', 'youtubedl', 'libreoffice', 'geogebra', 'linux', 'wayland', 'Steam', 'LearnJapanese']
base_url = '*://*.reddit.com/r/'

# Generate the whitelist based on the keywords
whitelist = [f'{base_url}{keyword}/*' for keyword in keywords]
# Set the whitelist in the config
config.set('content.blocking.whitelist', whitelist)

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

# Keybinding to temporarily allow Facebook when using hints
config.bind('af', 'config-list-add content.blocking.whitelist *.facebook.com;; hint links;;cmd-later 10000 config-list-remove content.blocking.whitelist *.facebook.com')

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
c.content.webgl = True
c.messages.timeout = 2000

# Tabs
c.session.lazy_restore = True
c.tabs.show = "multiple"
c.tabs.position = "top"
c.tabs.max_width = 200

c.url.searchengines = {
    "DEFAULT": "https://lite.duckduckgo.com/lite/?q={}",
    "yt": "https://farside.link/https://www.youtube.com/results?search_query={}",
}

c.qt.args = [ "enable-features=VaapiIgnoreDriverChecks",]

with config.pattern("*://discord.com/*") as p:
    p.content.media.audio_video_capture = True
    p.content.autoplay = True
c.downloads.location.directory = "~/2doCiclo/UNIDAD1/"

