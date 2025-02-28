#Javascript
config.set('content.javascript.enabled', False, 'wikipedia.org')
config.set('content.javascript.enabled', False, 'genius.com')
config.set('content.javascript.enabled', False, '*.fandom.com')

c.url.searchengines = {
    "DEFAULT": "https://www.mojeek.com/search?q={}&hp=minimal&qss=Brave,Startpage",
    "!i": "https://www.mojeek.com/search?q={}&fmt=images",
    "!gh": "https://github.com/search?q={}",
    "!yt": "https://www.youtube.com/results?search_query={}",
    "!arxiv": "https://arxiv.org/search/?query={}&searchtype=all",
    "!wolfram": "https://www.wolframalpha.com/input/?i={}",
}
c.url.default_page = "https://lite.duckduckgo.com"

with config.pattern("*://discord.com/*") as p:
    p.content.autoplay = True
    p.content.desktop_capture = True
    p.content.media.audio_capture = True
