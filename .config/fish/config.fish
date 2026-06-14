# Abbreviation
# --- Git Abbreviation ---
abbr -a gco git checkout
abbr -a gcb git checkout -b
abbr -a g git
abbr -a gp git push
abbr -a gc git commit -m ""
abbr -a gs git status
abbr -a ga git add
abbr -a gaa git add --all
abbr -a gla git log --oneline --graph --decorate
abbr -a gm git merge
abbr -a gb git branch
abbr -a gpl git pull
#Outils de sauvetage
abbr -a gcl git clone
abbr -a gds git diff --staged
abbr -a grs git restore --staged

# --- Neovim Abbreviation ---
abbr -a v nvim
abbr -a vi nvim
abbr -a vim nvim



#Acces au config
abbr -a nconf nvim ~/.config/nvim/
abbr -a fconf nvim ~/.config/fish/config.fish
abbr -a hconf nvim ~/.config/hypr/hyprland.conf

# Utilisation avec des privilèges (si nécessaire)
abbr -a snvim sudo nvim

abbr -a cd z


# docker
abbr -a dcd docker compose down
abbr -a dcu docker compose up -d
abbr -a dc docker compose
abbr -a dce docker compose exec db mariadb -u root -p

alias ls="eza --icons"
alias li="eza -la --icons"
alias lt="eza --tree --icons -L 2"
alias cat ="bat"
alias grep="rg"




set -gx EDITOR nvim
set -gx VISUAL nvim
# S'assurer que les caractères Unicode/Nerd Font s'affichent bien
set -gx LANG fr_FR.UTF-8
set -gx LC_ALL fr_FR.UTF-8
#starship init fish | source

# Mammouth Code
set -gx PATH $HOME/.mammouth/bin $PATH


