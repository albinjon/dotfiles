# PATH configurations
typeset -U path
path=(
  $HOME/bin
  $HOME/.deno/bin
  /usr/local/bin
  $HOME/Programmering/apps
  $HOME/.local/bin
  $HOME/.local/bin/nvim/bin
  $HOME/.config/emacs/bin
  $path
)


function cos() {
    BUFFER="cd ~/Programmering/careos-backend && npm run cos"
    zle accept-line
}
zle -N cos
bindkey '^[s' cos


# Environment variables
export XDG_CONFIG_HOME="$HOME/.config"
export CAREOS_LOG_FORMAT="PLAIN"
export CAREOS_ENABLE_SHUTDOWN_HOOKS="false"
ALTERNATE_EDITOR="nvim"
EDITOR="nvim"
VISUAL="nvim"
export ALTERNATE_EDITOR EDITOR VISUAL

# Oh My Zsh configuration
ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="daveverwer"

# Load essential Oh My Zsh components for prompt
source $ZSH/lib/git.zsh
source $ZSH/lib/theme-and-appearance.zsh
source $ZSH/lib/completion.zsh
source $ZSH/lib/functions.zsh
source $ZSH/lib/misc.zsh
source $ZSH/lib/termsupport.zsh
source $ZSH/lib/async_prompt.zsh
source $ZSH/themes/$ZSH_THEME.zsh-theme

# Defer loading of other Oh My Zsh components
source $HOME/.zsh-defer/zsh-defer.plugin.zsh
zsh-defer source $ZSH/oh-my-zsh.sh
plugins=(zsh-autosuggestions fast-syntax-highlighting)

# Aliases
alias gcam="git commit -am" gco="git checkout" gp="git push" gpl="git pull" gaa="git add -A" \
      gpo="git push -u origin" gs="git status" gst="git stash" gstp="git stash pop" \
      gmm="git merge main" gsw="git switch -" gd="git diff" \
      sketch="nohup sketchybar >/dev/null 2>&1 &" resketch="sketchybar --reload" \
      pip="pip3" chx="chmod +x" py="python3"

# Functions
run_doa() {
    npx turbo run dev --filter="*doa*" --filter="*file-persister*" --filter="*config*" --filter="*organization*" --filter="*barcode*" --filter="*finalizer*" --filter="*mocks*"
}

run_e2e() {
    npx turbo run dev --filter="*doa*" --filter="*file-persister*" --filter="*config*" --filter="*organization*" --filter="*mro*" --filter="*collection*" --filter="*gates*" --filter="*workplace*" --filter="*finalizer*" --filter="*cgm*"  --filter="*maestro*" --concurrency=20
}
# --filter="*event-dump*"

# Lazy-load NVM
export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  unset -f nvm node npm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}
nvm() { lazy_load_nvm && nvm "$@"; }
node() { lazy_load_nvm && node "$@"; }
npm() { lazy_load_nvm && npm "$@"; }

# Defer FZF loading
zsh-defer source $HOME/.fzf.zsh

# Disable untracked files dirty status
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Global aliases
# alias -g G='| grep' P='| pbcopy'

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
