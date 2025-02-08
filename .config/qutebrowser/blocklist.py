# Define keywords and subdomains
# Add WhatsApp domains to the whitelist
whitelist = [
    '*://web.whatsapp.com/*',
    '*://*.whatsapp.net/*',
    '*://*.redditstatic.com/*',
    '*://*.reddit.com/*',
    '*://*.redd.it/*',
    '*://*.redditmedia.com/*'
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
c.content.javascript.log_message.excludes = {"userscript:_qute_stylesheet": ["*Refused to apply inline style because it violates the following Content Security Policy directive: *"], 
                                             "userscript:_qute_js": ["*TrustedHTML*"]}
