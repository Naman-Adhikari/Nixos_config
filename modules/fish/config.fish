
# Add ~/bin to PATH if it exists
if test -d ~/bin
    set -gx PATH ~/bin $PATH
end
set -e fish_command_not_found

# Run fastfetch only inside Ghostty
if test "$TERM_PROGRAM" = "ghostty"
    fastfetch
end

# Atuin (history)
atuin init fish | source

# Zoxide (directory jumping)
zoxide init fish | source

# Direnv (environment)
direnv hook fish | source

# Starship prompt
starship init fish | source


# -------------------------------
# Abbreviations
# -------------------------------
abbr -a n "nvim"
abbr -a ga "git add ."
abbr -a gs "git status"
abbr -a gm "git commit -m "
abbr -a gp "git push"
abbr -a rebs "sudo nixos-rebuild switch --flake ~/.dotfiles"
abbr -a reb "sudo nixos-rebuild test --flake ~/.dotfiles"
abbr -a conf "nvim ~/.dotfiles/configuration.nix"
abbr -a hom "nvim ~/.dotfiles/home.nix"
abbr -a homs "home-manager switch --flake ~/.dotfiles"
abbr -a homb "home-manager build --flake ~/.dotfiles"
abbr -a shell "nix-shell"
abbr -a ais "sudo systemctl stop ollama.service"
abbr -a ai "sudo systemctl start ollama.service"
abbr -a qwen "ollama run qwen2.5-coder:1.5b"
abbr -a bluetooth "python3 ~/Programming/Noframe/python/pyprojects/bluetooth/bluetooth.py"
abbr -a imgsort "python3 ~/Programming/Noframe/python/pyprojects/imagesorter/imagesorter.py"
abbr -a tlp "sudo tlp start"
abbr -a rmgen "python3 ~/Programming/Noframe/python/pyprojects/homgenremover/homgenremover.py"
abbr -a gen "home-manager generations"


# -------------------------------
# Functions
# -------------------------------
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    set cwd (cat "$tmp")
    if test -n "$cwd" -a "$cwd" != "$PWD"
        cd "$cwd"
    end
    rm -f "$tmp"
end
