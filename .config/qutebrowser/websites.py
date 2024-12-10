#Javascript
config.set('content.javascript.enabled', False, 'wikipedia.org')
config.set('content.javascript.enabled', False, 'genius.com')
config.set('content.javascript.enabled', False, '*.fandom.com')

c.url.searchengines = {
    "DEFAULT": "https://lite.duckduckgo.com/lite/?q={}",
}
c.url.default_page = "https://lite.duckduckgo.com"

with config.pattern("*://discord.com/*") as p:
    p.content.autoplay = True
    p.content.desktop_capture = True
    p.content.media.audio_capture = True
