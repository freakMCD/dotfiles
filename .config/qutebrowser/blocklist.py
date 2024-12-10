# Define keywords and subdomains
keywords = ['qutebrowser', 'math', 'AskPhysics', 'linuxquestions', 'hyprland', 'bash', 'archlinux', 'libreoffice', 'geogebra', 'linux', 'wayland', 'Steam', 'LearnJapanese', 'neovim', 'LaTeX', 'youtubedl', 'DataHoarder', 'GreaseMonkey']
base_url = '*://*.reddit.com/r/'
whitelist = [f'{base_url}{keyword}/*' for keyword in keywords]
# Add WhatsApp domains to the whitelist
whitelist += [
    '*://web.whatsapp.com/*',
    '*://*.whatsapp.net/*',
    '*://*.redditstatic.com/*',
    '*://*.youtube.com/watch?v=*',
    '*://*.youtube.com/playlist?list=PL*',
    '*://*.youtube.com/s/*',
    '*://*.youtube.com/feed/playlists',
]

config.set('content.blocking.whitelist', whitelist)

# Adblock
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt',
                                    'https://easylist.to/easylist/easyprivacy.txt',
                                    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt',
                                    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt',
                                    ]
c.content.blocking.hosts.lists = ['http://sbc.io/hosts/alternates/porn-social-only/hosts',]
