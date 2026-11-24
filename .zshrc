# --- Git Aliases ---
alias gco="git checkout"
alias gcb="git checkout -b"
alias g="git"
alias gp="git push"
alias gc="git commit -m"
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gla="git log --oneline --graph --decorate"
alias gm="git merge"
alias gb="git branch"
alias gpl="git pull"
# Outils de sauvetage
alias gcl="git clone"
alias gds="git diff --staged"
alias grs="git restore --staged"

# --- Neovim Aliases ---
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Acces au config
alias nconf="nvim ~/.config/nvim/"
alias fconf="nvim ~/.config/fish/config.fish"
alias hconf="nvim ~/.config/hypr/hyprland.conf"
alias zconf="nvim ~/.zshrc"

# Utilisation avec des privilèges (si nécessaire)
alias snvim="sudo nvim"

# docker
alias dcd="docker compose down"
alias dcu="docker compose up -d"
alias dc="docker compose"
alias dce="docker compose exec db mariadb -u root -p"

# Outils modernes
alias ls="eza --icons"
alias li="eza -la --icons"
alias lt="eza --tree --icons -L 2"
alias cat="bat"
alias grep="rg"

# Variables d'environnement
export EDITOR=nvim
export VISUAL=nvim
# S'assurer que les caractères Unicode/Nerd Font s'affichent bien
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8

# Mammouth Code
export PATH="$HOME/.mammouth/bin:$PATH"

# --- Fonctions ---
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Initialisation des outils (Starship & Zoxide)
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"

# --- Configuration de base Zsh ---
# Historique
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# FZF (Recherche floue)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Complétion
autoload -Uz compinit
compinit

# Configurer la complétion pour les alias de eza
compdef _eza ls li lt

# --- Plugins ---
# Auto-suggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (doit être le dernier plugin chargé)
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Alias personnalisé
alias ll='ls -l'

# Fastfetch au démarrage
fastfetch

