# zmodload zsh/zprof
# Path configurations
export DENO_INSTALL="$HOME/.deno"
export PATH="$HOME/bin:$DENO_INSTALL/bin:/usr/local/bin:$HOME/Programmering/apps:$PATH:$HOME/.local/bin:$HOME/.config/emacs/bin"
export XDG_CONFIG_HOME="$HOME/.config"

# Environment variables
export CAREOS_LOG_FORMAT="PLAIN"
export CAREOS_ENABLE_SHUTDOWN_HOOKS="false"

# Editor configuration
export ALTERNATE_EDITOR="nvim"
export EDITOR="nvim"
export VISUAL="nvim"

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# # Load Zinit
# ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
# [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# source "${ZINIT_HOME}/zinit.zsh"

# Load Oh My Zsh
ZSH_THEME="daveverwer"
plugins=(
  zsh-autosuggestions
  fast-syntax-highlighting
)

# # Load theme
# zinit ice pick"themes/daveverwer.zsh-theme"
# zinit light ohmyzsh/ohmyzsh
#
# # Zinit plugins
# zinit ice wait'!' atload'_zsh_autosuggest_start' lucid
# zinit light zsh-users/zsh-autosuggestions
#
# zinit ice wait'!' atinit'zpcompinit; zpcdreplay' lucid
# zinit light zdharma-continuum/fast-syntax-highlighting
# #
# # Optimize compinit
# zinit ice wait'!' atload'zicompinit; zicdreplay' blockf
# zinit light zsh-users/zsh-completions


# Git aliases
alias gcam="git commit -am"
alias gco="git checkout"
alias gp="git push"
alias gpl="git pull"
alias gaa="git add -A"
alias gpo="git push -u origin"
alias gs="git status"
alias gst="git stash"
alias gstp="git stash pop"
alias gmm="git merge main"
alias gsw="git switch -"
alias gd="git diff"

# Other aliases
alias sketch="nohup sketchybar >/dev/null 2>&1 &"
alias resketch="sketchybar --reload"
alias pip="pip3"
alias chx="chmod +x"
alias py="python3"

# Complex commands as functions
run_doa() {
    npx turbo run dev --filter="*doa*" --filter="*file-persister*" --filter="*config*" --filter="*organization*" --filter="*barcode*"
}

run_e2e() {
    npx turbo run dev --filter="*doa*" --filter="*file-persister*" --filter="*config*" --filter="*organization*" --filter="*mro*" --filter="*collection*" --filter="*gates*" --filter="*workplace*" --filter="*finalizer*" --filter="*cgm*" --filter="*event-dump*" --filter="*maestro*" --concurrency=20
}

# Lazy-load NVM
export NVM_DIR="$HOME/.nvm"

lazy_load_nvm() {
unset -f nvm
unset -f node
unset -f npm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() {
  lazy_load_nvm
  node $@
}
nvm() {
  lazy_load_nvm
  nvm $@
}
npm() {
  lazy_load_nvm
  npm $@
}

# FZF key bindings and completion
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# Disable untracked files dirty status
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Global aliases (Zsh-specific feature)
alias -g G='| grep'
alias -g P='| pbcopy'

# Speed up shell startup
# ZINIT[COMPINIT_OPTS]=-C
# zprof
