-----------------
--- EXECS -------
-----------------

hl.on("hyprland.start", function()
	--	hl.exec_cmd("bash -c '/home/lostfromlight/.dotfiles/home/scripts/winsound.sh'")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("bash -c 'sleep 1 && swww-daemon'")
	-- hl.exec_cmd("bash -c 'emacs --daemon'")
	hl.exec_cmd("bash -c 'qs & sleep 0.3; qs ipc call lockscreen lock'")
	hl.exec_cmd("dunst")
	hl.exec_cmd("pypr")
	hl.exec_cmd("mpd")
end)
