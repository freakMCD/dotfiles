# Key mappings
# 'Leader' key binding -- for general personal maps
leader = "<Space>"
# 'LocalLeader' key binding -- intended for 'in-page' personal maps
lleader = ","

c.hints.chars = "qweasdzxc"
config.bind('f', 'mode-leave', mode='hint')

# Common prefix for video link selectors
prefix = 'a[href*='
# Video link selectors
video_selector_parts = ['youtu', 'share/', 'reel/', 'watch?']
# Full video link selector 
video_selector = ' , '.join([f'{prefix}"{part}"]' for part in video_selector_parts])

# Specific selectors
youtube_selector = '#thumbnail.inline-block'

# Set selectors for video hints
config.set('hints.selectors', {'videos': [video_selector]}, pattern='*')
config.set('hints.selectors', {'videos': [youtube_selector]}, pattern='*://*.youtube.com/*')

bind = {
    "gd": "open https://discord.com/channels/@me",
    "gw": "open https://web.whatsapp.com",
    "gD": "open -t https://discord.com/channels/@me",
    "gW": "open -t https://web.whatsapp.com",

	leader + "js": "config-cycle content.javascript.enabled true false",
    leader + "a": "config set content.blocking.whitelist+='*://*.reddit.com/*'",
	leader + "b": "config-cycle tabs.show switching always",
	leader + leader: "config-cycle colors.webpage.darkmode.enabled true false;; config-cycle content.user_stylesheets [] ['~/.config/qutebrowser/css/gruvbox-all-sites.css']",
	leader + "v": "config-source ;; message-info 'qutebrowser reloaded'",
    ## mpv 
    lleader + "m": "hint videos userscript qute-mpv",
    lleader + "p": "hint --rapid videos spawn --userscript add-to-mpv-playlist {hint-url}",
    lleader + "f": "hint videos spawn --detach mpv {hint-url} --profile=fastYT",

    ## qute-pass
    'zl': 'spawn --userscript qute-pass',
    'zul': 'spawn --userscript qute-pass --username-only',
    'zpl': 'spawn --userscript qute-pass --password-only',
    'zol': 'spawn --userscript qute-pass --otp-only',

    ## hints
	"i": "hint --first inputs",
    "I": "hint inputs",

    ## qutebrowser mappings
    'Sd': 'bookmark-del'
    'SD', 'quickmark-del'
	'/': 'set statusbar.show always;; cmd-set-text /',
	"/": "set statusbar.show always;; cmd-set-text /",
	"J": "tab-prev",
	"K": "tab-next",
	"j": "scroll-px 0 200",
	"k": "scroll-px 0 -200",
	"l": "scroll-px 100 0",
}
for a, b in bind.items():
    config.bind(a, b)

config.bind('o', 'set statusbar.show always;; cmd-set-text -s :open')
config.bind('O', 'set statusbar.show always;; cmd-set-text -s :open -t')
config.bind(':', 'set statusbar.show always;; cmd-set-text :')
config.bind('<Escape>', 'mode-enter normal;; set statusbar.show in-mode', mode='command')
config.bind('<Return>', 'command-accept;; set statusbar.show in-mode', mode='command')
config.bind('<Alt>', 'command-accept;; set statusbar.show in-mode', mode='command')
config.bind('<Ctrl-SHIFT-Z>', 'mode-leave', mode='passthrough')

config.set("input.mode_override", "passthrough", "docs.google.com")
config.bind('<Alt-1>', 'tab-focus 1', mode='passthrough')
config.bind('<Alt-2>', 'tab-focus 2', mode='passthrough')
config.bind('<Alt-3>', 'tab-focus 3', mode='passthrough')
config.bind('<Alt-4>', 'tab-focus 4', mode='passthrough')
config.bind('<Alt-5>', 'tab-focus 5', mode='passthrough')
config.bind('<Alt-6>', 'tab-focus 6', mode='passthrough')
config.bind('<Alt-7>', 'tab-focus 7', mode='passthrough')
config.bind('<Alt-8>', 'tab-focus 8', mode='passthrough')
config.bind('<Alt-9>', 'tab-focus 9', mode='passthrough')

config.unbind("q", mode="normal")

