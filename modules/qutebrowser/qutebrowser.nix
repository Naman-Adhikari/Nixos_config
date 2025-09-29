{config, pkgs, ...}:

{
  xdg.configFile."qutebrowser/config.py".text = ''
config.load_autoconfig()


#-------------------Colors-------------------------
fg = "#d8dee9"
bg = "#2e3440"
accent = "#88c0d0"
accent2 = "#81a1c1"
red = "#bf616a"
green = "#a3be8c"


#--------------Some functionality-------------------
c.auto_save.session = True
c.content.desktop_capture = True
c.content.private_browsing = False
c.scrolling.bar = "always"
c.scrolling.smooth = True
c.window.transparent = True
c.zoom.default = "125%"

#---------------Ad-Block config----------------------
c.content.blocking.enabled = True
c.content.blocking.method = "adblock"
c.content.blocking.adblock.lists = [
	"https://easylist.to/easylist/easylist.txt",        
	"https://easylist.to/easylist/easyprivacy.txt"
]


#---------------Some keybinds-----------------------
config.bind('j', 'scroll-px 0 80')
config.bind('k', 'scroll-px 0 -80')
config.bind('J', 'tab-prev')  
config.bind('K', 'tab-next')
config.bind('<Ctrl-d>', 'scroll-px 0 300')
config.bind('<Ctrl-u>', 'scroll-px 0 -300')
config.bind('<Ctrl-p>', 'open -p')


#--------------Enabling dark mode----------------------
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"

#------------------Statusbar-------------------------
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.command.bg = bg
c.colors.statusbar.command.fg = fg
c.colors.statusbar.url.fg = accent
c.colors.statusbar.url.success.https.fg = green
c.colors.statusbar.url.hover.fg = accent2
c.statusbar.show = "in-mode"

#-------------Tabs-------------------------
c.colors.tabs.bar.bg = bg
c.colors.tabs.even.bg = bg
c.colors.tabs.odd.bg = bg
c.colors.tabs.even.fg = fg
c.colors.tabs.odd.fg = fg
c.colors.tabs.selected.even.bg = fg
c.colors.tabs.selected.even.fg = bg
c.colors.tabs.selected.odd.bg = fg
c.colors.tabs.selected.odd.fg = bg
c.tabs.show = "multiple"
c.tabs.padding = {"top": 3, "bottom": 3, "left": 9, "right": 9}
c.tabs.width = "7%"
c.tabs.title.format = "{current_title}"
c.tabs.position = "top"

#--------------Completion---------------------
c.colors.completion.fg = fg
c.colors.completion.even.bg = bg
c.colors.completion.odd.bg = bg
c.colors.completion.match.fg = accent
c.colors.completion.item.selected.fg = fg
c.colors.completion.item.selected.bg = accent2
c.colors.completion.category.bg = bg
c.colors.completion.category.fg = fg

#------------------Hints----------------------
c.colors.hints.bg = bg
c.colors.hints.fg = fg
c.hints.border = fg

#----------------Messages-------------------
c.colors.messages.info.bg = bg
c.colors.messages.info.fg = fg
c.colors.messages.error.bg = bg
c.colors.messages.error.fg = red

#---------------Downloads-----------------
c.colors.downloads.bar.bg = bg
c.colors.downloads.start.bg = green
c.colors.downloads.stop.bg = red
c.colors.downloads.error.bg = red
c.confirm_quit = ["downloads"]
c.downloads.location.remember = True
c.downloads.position = "bottom"
c.downloads.remove_finished = 10000

#-----------Tooltip & webpage-------------
c.colors.tooltip.bg = bg
c.colors.webpage.bg = bg

#---------------Fonts----------------------
c.fonts.default_size = "13pt"
c.fonts.web.family.standard = "CaskaydiaCove"
c.fonts.web.family.serif = "CaskaydiaCove"
c.fonts.web.family.sans_serif = "CaskaydiaCove"
c.fonts.web.family.fixed = "CaskaydiaCove"
'';
}
	 
