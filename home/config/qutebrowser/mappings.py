# Key mappings
# 'Leader' and 'Local Leader' for general personal maps and <in-page> maps
leader, lleader = "<Space>", ","

c.hints.chars = "qweasdzxc"
config.bind('f', 'mode-leave', mode='hint')

# Set selectors
video_selector = ', '.join([f'a[href*="{part}"]' for part in ['youtu', 'share/', 'watch?']])
config.set('hints.selectors', {'videos': [video_selector]}, pattern='*')

bind = {
	leader + "js": "config-cycle content.javascript.enabled true false",
    leader + "b": "config-cycle tabs.show always never",
	leader + leader: "config-cycle colors.webpage.darkmode.enabled true false;; config-cycle content.user_stylesheets [] ['css/gruvbox.css']",
	leader + "v": "config-source ;; message-info 'qutebrowser reloaded'",
    ## mpv 
    lleader + "m": "hint videos spawn --detach mpv --ytdl-raw-options=cookies-from-browser=firefox:~/.librewolf/bixoef6e.default {hint-url}",
    lleader + "M": "spawn --detach mpv {url}",


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
# Auto-fill both (if supported)
config.bind(',p', "spawn --userscript qute-pass")
