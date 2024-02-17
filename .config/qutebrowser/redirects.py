from qutebrowser.api import interceptor
from urllib.parse import urljoin
from PyQt6.QtCore import QUrl
import operator

o = operator.methodcaller
s = 'setHost'
i = interceptor

def farside(url: QUrl, i) -> bool:
    url.setHost('farside.link')
    p = url.path().strip('/')
    url.setPath(urljoin(i, p))
    return True

def nitter(url: QUrl) -> bool:
    return farside(url, '/nitter/')
def rimgo(url: QUrl) -> bool:
    return farside(url, '/rimgo/')
def scribe(url: QUrl) -> bool:
    return farside(url, '/scribe/')
def invid(url: QUrl) -> bool:
    return farside(url, '/invidious/')
def simplytranslate(url: QUrl) -> bool:
    return farside(url, '/simplytranslate/')
def proxitok(url: QUrl) -> bool:
    return farside(url, '/proxitok/')
def quetre (url: QUrl) -> bool:
    return farside(url, '/quetre/')
def breezewiki (url: QUrl) -> bool:
    return farside(url, '/breezewiki/')
def dumb (url: QUrl) -> bool:
    return farside(url, '/dumb/')
def anonymousoverflow (url: QUrl) -> bool:
    return farside(url, '/anonymousoverflow/')

map = {
        "twitter.com": nitter,
        "mobile.twitter.com": nitter,

        "imgur.com" : rimgo,
        "medium.com" : scribe,
        "translate.google.com" : simplytranslate,
        "vm.tiktok.com" : proxitok,
        "www.tiktok.com" : proxitok,
        "www.quora.com": quetre,
        "fandom.com": breezewiki,
        "www.fandom.com": breezewiki,
        "genius.com" : dumb,
        "stackoverflow.com" : anonymousoverflow,
        
        "tumblr.com" : o(s, 'splashblr.fly.dev'),
        "www.goodreads.com" : o(s, 'bl.vern.cc'),
        }
def f(info: i.Request):
    if (info.resource_type != i.ResourceType.main_frame or
            info.request_url.scheme() in {"data", "blob"}):
        return
    url = info.request_url
    redir = map.get(url.host())
    if redir is not None and redir(url) is not False:
        info.redirect(url)
i.register(f)
