# Key mappings
# 'Leader' key binding -- for general personal maps
leader = "<Space>"
# 'LocalLeader' key binding -- intended for 'in-page' personal maps
lleader = ","

c.hints.chars = "asdghzxcvb"
config.bind('f', 'mode-leave', mode='hint')
config.bind('e', 'mode-leave', mode='hint')

# Common prefix for video link selectors
prefix = 'a[href*='
# Video link selectors
video_selector_parts = ['youtu', 'share/', 'reel/']
# Full video link selector 
video_selector = ' , '.join([f'{prefix}"{part}"]' for part in video_selector_parts])

# Specific selectors
twitch_selector= 'a[data-a-target*="preview-card-image-link"]'
youtube_selector = 'a[id*="video-title"]'

# Set selectors for video hints
config.set('hints.selectors', {'videos': [video_selector]}, pattern='*')
config.set('hints.selectors', {'videos': [twitch_selector]}, pattern='*://*.twitch.tv/*')
config.set('hints.selectors', {'videos': [youtube_selector]}, pattern='*://*.youtube.com/*')

bind = {
    "gd": "open https://discord.com/channels/@me",
    "gw": "open https://web.whatsapp.com",
    "gD": "open -t https://discord.com/channels/@me",
    "gW": "open -t https://web.whatsapp.com",

	leader + "js": "config-cycle content.javascript.enabled true false",
	leader + "t": "config-cycle tabs.show switching always",
	leader + "v": "config-source ;; message-info 'qutebrowser reloaded'",
    ## mpv 
    lleader + "m": "hint videos spawn --detach mpv --ytdl-format='bestvideo[height<=720]+bestaudio/best' {hint-url} --force-window=yes",
    lleader + "M": "hint links spawn --detach mpv {hint-url} --force-window=yes",
    ## hints
    "e": "hint button",
	"i": "hint --first inputs",
    "I": "hint inputs",
    ## qutebrowser mappings
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

config.unbind("q", mode="normal")

