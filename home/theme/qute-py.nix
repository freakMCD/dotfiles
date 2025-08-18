{config, ...}:
{
  home.file."nix/home/config/qutebrowser/colors.py".text = /* python */''
    bg0 = "#${config.colors.bg0}"
    bg1 = "#${config.colors.bg1}"
    bg2 = "#${config.colors.bg2}"
    bg3 = "#${config.colors.bg3}"
    bg4 = "#${config.colors.bg4}"

    gray = "#${config.colors.gray}"
    muted_white = "#${config.colors.muted_white}"

    red = "#${config.colors.red}"
    green = "#${config.colors.green}"
    yellow = "#${config.colors.yellow}"
    blue = "#${config.colors.blue}"
    magenta = "#${config.colors.magenta}"
    cyan = "#${config.colors.cyan}"
    orange = "#${config.colors.orange}"
    white = "#${config.colors.white}"

    bright_red = "#${config.colors.b_red}"
    bright_green = "#${config.colors.b_green}"
    bright_yellow = "#${config.colors.b_yellow}"
    bright_blue = "#${config.colors.b_blue}"
    bright_magenta = "#${config.colors.b_magenta}"
    bright_cyan = "#${config.colors.b_cyan}"
    bright_orange = "#${config.colors.b_orange}"
    bright_white = "#${config.colors.b_white}"

    ### Completion
    c.colors.completion.fg = [muted_white, bright_cyan, bright_yellow]
    c.colors.completion.odd.bg = bg1
    c.colors.completion.even.bg = c.colors.completion.odd.bg
    c.colors.completion.category.fg = bright_blue
    c.colors.completion.category.bg = bg2
    c.colors.completion.category.border.top = c.colors.completion.category.bg
    c.colors.completion.category.border.bottom = c.colors.completion.category.bg
    c.colors.completion.item.selected.fg = white
    c.colors.completion.item.selected.bg = bg4
    c.colors.completion.item.selected.border.top = bg3
    c.colors.completion.item.selected.border.bottom = c.colors.completion.item.selected.border.top
    c.colors.completion.item.selected.match.fg = bright_orange
    c.colors.completion.match.fg = c.colors.completion.item.selected.match.fg
    c.colors.completion.scrollbar.fg = c.colors.completion.item.selected.fg
    c.colors.completion.scrollbar.bg = c.colors.completion.category.bg
    
    ### Context menu
    c.colors.contextmenu.disabled.bg = bg3
    c.colors.contextmenu.disabled.fg = gray
    c.colors.contextmenu.menu.bg = bg4
    c.colors.contextmenu.menu.fg =  white
    c.colors.contextmenu.selected.bg = bg2
    c.colors.contextmenu.selected.fg = c.colors.contextmenu.menu.fg
    
    ### Downloads
    c.colors.downloads.bar.bg = bg1
    c.colors.downloads.start.fg = bg1
    c.colors.downloads.start.bg = bright_blue
    c.colors.downloads.stop.fg = c.colors.downloads.start.fg
    c.colors.downloads.stop.bg = bright_cyan
    c.colors.downloads.error.fg = bright_red
    
    ### Hints
    c.colors.hints.fg = 'rgb(0,0,0)'
    c.colors.hints.bg = bright_yellow
    c.colors.hints.match.fg = red
    
    ### Keyhint widget
    c.colors.keyhint.fg = bright_white
    c.colors.keyhint.suffix.fg = white
    c.colors.keyhint.bg = bg1
    
    ### Messages
    c.colors.messages.error.fg = bg1
    c.colors.messages.error.bg = bright_red
    c.colors.messages.error.border = c.colors.messages.error.bg
    c.colors.messages.warning.fg = bg1
    c.colors.messages.warning.bg = bright_magenta
    c.colors.messages.warning.border = c.colors.messages.warning.bg
    c.colors.messages.info.fg = white
    c.colors.messages.info.bg = bg1
    c.colors.messages.info.border = c.colors.messages.info.bg
    
    ### Prompts
    c.colors.prompts.fg = white
    c.colors.prompts.border = f'1px solid {bg2}'
    c.colors.prompts.bg = bg4
    c.colors.prompts.selected.bg = bg3
    
    ### Statusbar
    c.colors.statusbar.normal.fg = white
    c.colors.statusbar.normal.bg = bg1
    c.colors.statusbar.insert.fg = bright_green
    c.colors.statusbar.insert.bg = bg1
    c.colors.statusbar.passthrough.fg = bright_blue
    c.colors.statusbar.passthrough.bg = bg1
    c.colors.statusbar.private.fg = bright_magenta
    c.colors.statusbar.private.bg = bg1
    c.colors.statusbar.command.fg = white
    c.colors.statusbar.command.bg = bg2
    c.colors.statusbar.command.private.fg = c.colors.statusbar.private.fg
    c.colors.statusbar.command.private.bg = c.colors.statusbar.command.bg
    c.colors.statusbar.caret.fg = bright_magenta
    c.colors.statusbar.caret.bg = bg1
    c.colors.statusbar.caret.selection.fg = c.colors.statusbar.caret.fg
    c.colors.statusbar.caret.selection.bg = bright_magenta
    c.colors.statusbar.progress.bg = bright_blue
    c.colors.statusbar.url.fg = bright_white
    c.colors.statusbar.url.error.fg = red
    c.colors.statusbar.url.hover.fg = bright_orange
    c.colors.statusbar.url.success.http.fg = bright_red
    c.colors.statusbar.url.success.https.fg = white
    c.colors.statusbar.url.warn.fg = bright_magenta
    
    ### tabs
    c.colors.tabs.bar.bg = bg1
    c.colors.tabs.indicator.start = yellow
    c.colors.tabs.indicator.stop = bright_blue
    c.colors.tabs.indicator.error = red
    c.colors.tabs.odd.fg = white
    c.colors.tabs.odd.bg = bg3
    c.colors.tabs.even.fg = c.colors.tabs.odd.fg
    c.colors.tabs.even.bg = c.colors.tabs.odd.bg
    c.colors.tabs.selected.odd.fg = white
    c.colors.tabs.selected.odd.bg = bg1
    c.colors.tabs.selected.even.fg = c.colors.tabs.selected.odd.fg
    c.colors.tabs.selected.even.bg = bg1
    c.colors.tabs.pinned.even.bg = bg0
    c.colors.tabs.pinned.even.fg = white
    c.colors.tabs.pinned.odd.bg = bg0
    c.colors.tabs.pinned.odd.fg = c.colors.tabs.pinned.even.fg
    c.colors.tabs.pinned.selected.even.bg = bg0
    c.colors.tabs.pinned.selected.even.fg = white
    c.colors.tabs.pinned.selected.odd.bg = c.colors.tabs.pinned.selected.even.bg
    c.colors.tabs.pinned.selected.odd.fg = c.colors.tabs.pinned.selected.odd.fg
  '';
  home.file."nix/home/config/qutebrowser/blocked-hosts".text = ''
    youtube.com
    www.youtube.com
    m.youtube.com
    youtu.be
    www.youtube-nocookie.com
    s.ytimg.com
    i.ytimg.com
    ytimg.com
    googlevideo.com
    web.whatsapp.com
    whatsapp.net
    whatsapp.com
    allkpop.com
  '';
}
