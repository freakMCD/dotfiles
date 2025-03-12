#Javascript
config.set('content.javascript.enabled', False, 'wikipedia.org')
config.set('content.javascript.enabled', False, 'genius.com')
config.set('content.javascript.enabled', False, '*.fandom.com')

c.url.searchengines = {
    "DEFAULT": "https://www.mojeek.com/search?q={}&arc=none&hp=minimal&qsbu=0&qsba=1&qss=Brave%2CStartpage&foc=Custom",
    "lyrics": "https://www.lyrics.cat/search/?q={}",
    "gh": "https://github.com/search?q={}&type=code",
    "arxiv": "https://arxiv.org/search/?query={}&searchtype=all",
    "wolfram": "https://www.wolframalpha.com/input/?i={}",
}
c.url.default_page = "https://www.mojeek.com/search?q={}&arc=none&hp=minimal&qsbu=0&qsba=1&qss=Brave%2CStartpage&foc=Custom"

with config.pattern("*://discord.com/*") as p:
    p.content.autoplay = True
    p.content.desktop_capture = True
    p.content.media.audio_capture = True
