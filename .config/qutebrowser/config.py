import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig(False)

# Old
c.content.user_stylesheets = ["~/.config/qutebrowser/css/gruvbox-all-sites.css"]
config.source('mappings.py')
config.source('gruvbox.py')

c.content.autoplay = False
c.content.notifications.enabled = False
config.set('content.notifications.enabled', True, '*://web.whatsapp.com')

# Add WhatsApp domains to the whitelist
whitelist = [
    '*://web.whatsapp.com/*',
    '*://*.whatsapp.net/*',
    '*://*.youtube.com/watch?v=*',
    '*://*.youtube.com/playlist?list=PL*',
]

config.set('content.blocking.whitelist', whitelist)

# Adblock
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt',
                                    'https://easylist.to/easylist/easyprivacy.txt',
                                    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt',
                                    ]
c.content.blocking.hosts.lists = ['http://sbc.io/hosts/alternates/porn-social-only/hosts',]

# Javascript
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access-paste"
config.set('content.javascript.enabled', False, 'wikipedia.org')
config.set('content.javascript.enabled', False, 'genius.com')
config.set('content.javascript.enabled', False, '*.fandom.com')

# Darkmode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = "dark"
# General
c.fonts.default_size = "10pt"
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.completion.shrink = True
c.completion.open_categories = ["quickmarks", "bookmarks", "searchengines"]
c.content.fullscreen.window = True
c.content.webgl = True
c.messages.timeout = 2000
c.session.lazy_restore = True
c.tabs.show = "never"

c.url.searchengines = {
    "DEFAULT": "https://lite.duckduckgo.com/lite/?q={}",
}
c.url.default_page = "https://lite.duckduckgo.com"

c.qt.args = [ "enable-features=VaapiIgnoreDriverChecks",]

with config.pattern("*://discord.com/*") as p:
    p.content.media.audio_video_capture = True
    p.content.autoplay = True
c.downloads.location.directory = "~/2doCiclo/"

