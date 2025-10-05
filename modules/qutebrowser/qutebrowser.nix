{config, pkgs, ...}:

{
  xdg.configFile."qutebrowser/config.py".text = ''
config.load_autoconfig()


#-------------------Colors-------------------------
fg = "#d8dee9"     
bg = "#1e1e2e"      
accent = "#81a1c1"  
accent2 = "#bf616a" 
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
c.content.javascript.clipboard = "access-paste"
c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem']

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
config.bind('<Ctrl-b>', 'bookmark-add')
config.bind('b', 'open -t qute://bookmarks')
config.bind("<Ctrl-t>", "config-cycle tabs.position top left")
config.bind("D", "hint links spawn ~/.dotfiles/modules/qutebrowser/userscripts/yt-down-compress.sh {hint-url}")
config.bind("M", "hint links spawn mpv {hint-url}")









#--------------Enabling dark mode----------------------
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"

#------------------Statusbar-------------------------
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.insert.bg = accent      # blue for insert mode
c.colors.statusbar.passthrough.bg = "#425d89"
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.command.bg = bg
c.colors.statusbar.command.fg = fg
c.colors.statusbar.url.fg = accent
c.colors.statusbar.url.success.https.fg = green
c.colors.statusbar.url.hover.fg = accent2  # red accent on hover
c.statusbar.show = "in-mode"

#------------------scrollbar-----------------
c.colors.completion.scrollbar.bg = "#000000"
c.colors.completion.scrollbar.fg = "#938f90"

#------------------Tabs---------------------------------
c.colors.tabs.bar.bg = "#000000" 
c.colors.tabs.even.bg = "rgba(30, 30, 46, 150)" 
c.colors.tabs.odd.bg = "rgba(30, 30, 46, 150)"   
c.colors.tabs.even.fg = "#d8dee9"
c.colors.tabs.odd.fg = "#d8dee9"

c.colors.tabs.selected.even.bg = "#81a1c1"       
c.colors.tabs.selected.odd.bg = "#bf616a"         
c.colors.tabs.selected.even.fg = "#1e1e2e"
c.colors.tabs.selected.odd.fg = "#1e1e2e"

c.tabs.show = "multiple"
c.tabs.padding = {"top": 3, "bottom": 3, "left": 3, "right": 3}
c.tabs.width = "2%"
c.tabs.title.format = "{current_title}"
c.tabs.position = "top"
c.tabs.background = False

#-------------Completion---------------------
c.colors.completion.fg = fg
c.colors.completion.even.bg = bg
c.colors.completion.odd.bg = bg
c.colors.completion.match.fg = "#81a1c1"              # blue match
c.colors.completion.item.selected.fg = fg
c.colors.completion.item.selected.bg = "#bf616a"      # red selection
c.colors.completion.category.bg = bg
c.colors.completion.category.fg = fg

#------------------Hints----------------------
c.colors.hints.bg = bg
c.colors.hints.fg = "#81a1c1"  
c.hints.border = "#ffffff"

#----------------Messages-------------------
c.colors.messages.info.bg = bg
c.colors.messages.info.fg = fg
c.colors.messages.error.bg = bg
c.colors.messages.error.fg = "#bf616a"                 # red errors

#---------------Downloads-----------------
c.colors.downloads.bar.bg = bg
c.colors.downloads.start.bg = "#81a1c1"               # blue start
c.colors.downloads.stop.bg = "#bf616a"                # red stop
c.colors.downloads.error.bg = "#bf616a"               # red error
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

#--------------Custom Css-----------------
c.content.user_stylesheets = ["~/.dotfiles/modules/qutebrowser/style/youtube.css"]

'';
}
	 
