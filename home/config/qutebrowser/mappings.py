
# Leader Keys
leader, lleader = "<Space>", ","

# Hints
c.hints.chars = "qweasdzxc"
config.bind('f', 'mode-leave', mode='hint')

c.hints.selectors["video"] = ["video"]

bind = {
    # Toggles
	leader + "js": "config-cycle content.javascript.enabled true false",
    leader + "b": "config-cycle tabs.show always never",
	leader + leader: "config-cycle colors.webpage.darkmode.enabled true false;; config-cycle content.user_stylesheets [] ['css/gruvbox.css']",
	leader + "v": "config-source ;; message-info 'qutebrowser reloaded'",

    ## mpv 
    lleader + "m": "hint video spawn --detach mpv --ytdl-raw-options=cookies-from-browser=firefox {hint-url}",
    lleader + "M": "spawn --detach mpv {url}",


    ## Hints
	"i": "hint --first inputs",
    "I": "hint inputs",

    ## qutebrowser mappings
	"j": "scroll-px 0 200",
	"k": "scroll-px 0 -200",
}

# Apply all bindings
for key, command in bind.items():
    config.bind(key, command)

# Auto-fill pass
config.bind(',p', "spawn --userscript qute-pass")
