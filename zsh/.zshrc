# Enable zsh profiling
zmodload zsh/zprof

# Path configurations
path=(
  $HOME/bin
  $HOME/.deno/bin
  /usr/local/bin
  $HOME/Programmering/apps
  $HOME/.local/bin
  $HOME/.config/emacs/bin
  $path
)
export PATH

# Environment variables
export XDG_CONFIG_HOME="$HOME/.config"
export CAREOS_LOG_FORMAT="PLAIN"
export CAREOS_ENABLE_SHUTDOWN_HOOKS="false"
export ALTERNATE_EDITOR="nvim" EDITOR="nvim" VISUAL="nvim"

# Oh My Zsh configuration
ZSH_THEME="daveverwer"
plugins=(zsh-autosuggestions fast-syntax-highlighting)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

# Aliases
alias gcam="git commit -am" gco="git checkout" gp="git push" gpl="git pull" gaa="git add -A" \
      gpo="git push -u origin" gs="git status" gst="git stash" gstp="git stash pop" \
      gmm="git merge main" gsw="git switch -" gd="git diff" \
      sketch="nohup sketchybar >/dev/null 2>&1 &" resketch="sketchybar --reload" \
      pip="pip3" chx="chmod +x" py="python3"

# Functions
run_doa() {
    npx turbo run dev --filter="*doa*" --filter="*file-persister*" --filter="*config*" --filter="*organization*" --filter="*barcode*"
}

run_e2e() {
    npx turbo run dev --filter="*doa*" --filter="*file-persister*" --filter="*config*" --filter="*organization*" --filter="*mro*" --filter="*collection*" --filter="*gates*" --filter="*workplace*" --filter="*finalizer*" --filter="*cgm*" --filter="*event-dump*" --filter="*maestro*" --concurrency=20
}

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

# FZF key bindings and completion
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# Disable untracked files dirty status
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Global aliases
alias -g G='| grep' P='| pbcopy'

# End profiling
zprof
