local mainMod = "SUPER"

-- Application launches
hl.bind(
	mainMod .. " + SHIFT + A",
	hl.dsp.exec_cmd("WINEPREFIX=~/Altera wine ~/Altera/drive_c/altera/90/quartus/bin/quartus.exe")
)
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("steam-run java -jar ~/Games/TLauncher/TLauncher.jar"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("ghostty -e btop"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("ffplay -f v4l2 -i /dev/video0 -vf hflip"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("hyprsunset --temperature 5000"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("pkill hyprsunset"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("pkill waybar || waybar &"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("ghostty"))
-- hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("emacsclient -c"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("ghostty --class=nvim -e nvim"))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd('emacsclient --eval "(thanos/type)"'))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("app.zen_browser.zen"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("com.spotify.Client"))
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("shutdown now"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("qs ipc call lockscreen lock"))
hl.bind(mainMod .. " + 0", hl.dsp.exec_cmd("/home/lostfromlight/.dotfiles/home/scripts/riceswitch.sh"))
hl.bind(
	mainMod .. " + F1",
	hl.dsp.exec_cmd("bash -c 'cd ~/Programming/Frameworks/Mediapipe && nix develop -c python GestureControl/main.py &'")
)
hl.bind(
	mainMod .. " + SHIFT + A",
	hl.dsp.exec_cmd(
		"ghostty -e bash -c 'cd /home/lostfromlight/Programming/Noframe/rust/Ratatui/tuidev && nix develop /home/lostfromlight/Programming/Noframe -c cargo run'"
	)
)
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("pkill -f GestureControl/main.py"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("bongocat --config ~/.config/wayland-bongocat/bongocat.conf"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("~/.dotfiles/home/scripts/clipboard-rofi.sh"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("dbus-run-session -- steam-run $(which unityhub)"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("/home/lostfromlight/blender/result/bin/blender-fhs"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("ghostty -e ncmpcpp"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("floorp https://monkeytype.com"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("ghostty -e yazi"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("pypr expose"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr zoom ++0.5"))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("pypr zoom --0.5"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("com.discordapp.Discord"))

-- Window management
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("reboot"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + space", hl.dsp.window.float({ action = "toggle" }))

-- Scrolling layout navigation (move between columns)
--hl.bind(mainMod .. " + L", hl.dsp.layout("move +col"))
--hl.bind(mainMod .. " + H", hl.dsp.layout("move -col"))

-- Focus within columns (vertical) and between columns (horizontal)
-- In horizontal scroll mode: J/K move within column, H/L move between columns
hl.bind(mainMod .. " + J", hl.dsp.layout("focus d"))
hl.bind(mainMod .. " + K", hl.dsp.layout("focus u"))
hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))

-- Swap columns
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("swapcol l"))

-- Fit commands
hl.bind(mainMod .. " + apostrophe", hl.dsp.layout("fit active"))
hl.bind(mainMod .. " + semicolon", hl.dsp.layout("fit all"))

-- Promote/expel windows
hl.bind(mainMod .. " + ALT + L", hl.dsp.layout("expel"))
hl.bind(mainMod .. " + ALT + H", hl.dsp.layout("consume"))
-- Cycle column widths
hl.bind(mainMod .. " + O", hl.dsp.layout("colresize +conf"))

-- Move windows (uses standard dispatcher, works with scrolling layout)
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({ direction = "right" }))
--hl.bind(mainMod .. " + G", hl.dsp.window.group.toggle())

-- Workspaces
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Mouse bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Multimedia & brightness (binde = repeating)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true })
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("brightnessctl set 10%-"))
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("brightnessctl set 10%+"))

-- Screenshots
hl.bind("print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("ALT + print", hl.dsp.exec_cmd("grim -o eDP-1 - | wl-copy"))
hl.bind("CTRL + print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty --filename -'))
hl.bind(mainMod .. " + print", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png'))

-- Workspace rule
hl.workspace_rule({
	workspace = "special:exposed",
	gaps_out = 60,
	gaps_in = 30,
	border_size = 2,
	no_border = false,
	no_shadow = true,
})

-- Binds configuration
hl.config({
	binds = {
		workspace_back_and_forth = 1,
	},
})
