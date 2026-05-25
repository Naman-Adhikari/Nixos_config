------------------------
--- WINDOW RULES -------
------------------------

-- Ghostty rules
hl.window_rule({
	match = { class = "^(com.mitchellh.ghostty)$" },
	float = true,
	size = "1200 600",
})

-- ffplay rules
hl.window_rule({
	match = { class = "^(ffplay)$" },
	float = true,
	move = "1500 50",
	size = "400 300",
	pin = true,
})

-- emacs-float rules
hl.window_rule({
	match = { title = "^(emacs-float)$" },
	float = true,
	center = true,
})

-- python rules
hl.window_rule({
	match = { class = "^(python)$" },
	float = true,
	move = "1500 50",
	size = "400 300",
	pin = true,
})

-- Title-based float rules
hl.window_rule({
	match = { title = "^Open File$" },
	float = true,
})

hl.window_rule({
	match = { title = "^branchdialog$" },
	float = true,
})

hl.window_rule({
	match = { title = "^wlogout$" },
	float = true,
})

hl.window_rule({
	match = { title = "^Media viewer$" },
	float = true,
})

hl.window_rule({
	match = { title = "^Volume Control$" },
	float = true,
})

hl.window_rule({
	match = { title = "^Picture-in-Picture$" },
	float = true,
})
