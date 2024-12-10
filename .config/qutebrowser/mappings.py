# Key mappings
# 'Leader' and 'Local Leader' for general personal maps and <in-page> maps
leader, lleader = "<Space>", ","

c.hints.chars = "qweasdzxc"
config.bind('f', 'mode-leave', mode='hint')

# Common prefix for video link selectors
prefix = 'a[href*='
# Video link selectors
video_selector_parts = ['youtu', 'share/', 'watch?']
# Full video link selector 
video_selector = ' , '.join([f'{prefix}"{part}"]' for part in video_selector_parts])

# Set selectors for video hints
config.set('hints.selectors', {'videos': [video_selector]}, pattern='*')

bind = {
    "gd": "open https://discord.com/channels/@me",
    "gw": "open https://web.whatsapp.com",
    "gD": "open -t https://discord.com/channels/@me",
    "gW": "open -t https://web.whatsapp.com",

	leader + "js": "config-cycle content.javascript.enabled true false",
	leader + leader: "config-cycle colors.webpage.darkmode.enabled true false;; config-cycle content.user_stylesheets [] ['~/.config/qutebrowser/css/gruvbox-all-sites.css']",
	leader + "v": "config-source ;; message-info 'qutebrowser reloaded'",
    ## mpv 
    lleader + "m": "hint videos userscript qute-mpv",
    lleader + "f": "hint videos spawn --detach mpv {hint-url} --profile=fastYT",
    lleader + "F": "hint links spawn --detach mpv {hint-url}",

    ## qute-pass
    'zl': 'spawn --userscript qute-pass',
    'zul': 'spawn --userscript qute-pass --username-only',
    'zpl': 'spawn --userscript qute-pass --password-only',
    'zol': 'spawn --userscript qute-pass --otp-only',

    ## hints
	"i": "hint --first inputs",
    "I": "hint inputs",

    ## qutebrowser mappings
    'xD': "cmd-set-text bookmark-del",
    'xd': "cmd-set-text quickmark-del",
	"j": "scroll-px 0 200",
	"k": "scroll-px 0 -200",
	"l": "scroll-px 100 0",
}
for key, command in bind.items():
    config.bind(key, command)

for i in range(1, 10):
    config.bind(f'<Alt-{i}>', f'tab-focus {i}', mode='passthrough')
