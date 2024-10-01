# PATH exports
export DENO_INSTALL="$HOME/.deno"
export PATH="$HOME/bin:$DENO_INSTALL/bin:/usr/local/bin:$HOME/Programmering/apps:$PATH:$HOME/.local/bin:$HOME/.config/emacs/bin"

export XDG_CONFIG_HOME="$HOME/.config"

# Aliases
alias sketch="nohup sketchybar >/dev/null 2>&1 &"
alias resketch="sketchybar --reload"
alias gcam="git commit -am "
alias gco="git checkout"
alias gp="git push "
alias gpl="git pull"
alias gaa="git add -A"
alias gpo="git push -u origin "
alias gs="git status"
alias gst="git stash"
alias gstp="git stash pop"
alias gmm="git merge main"
alias gsw="git switch -"
alias gd="git diff"
alias pip="pip3"
alias chx="chmod +x"
alias py="python3"
alias run_doa='npx turbo run dev --filter="*doa*" --filter="*file-persister*" --filter="*config*" --filter="*organization*"'
alias run_e2e='npx turbo run dev --filter="*doa*" --filter="*file-persister*" --filter="*config*" --filter="*organization*" --filter="*mro*" --filter="*collection*" --filter="*gates*" --filter="*workplace*" --filter="*finalizer*" --filter="*cgm*" --filter="*event-dump*" --filter="*maestro*" --concurrency=20'
alias em='f() { if [ -n "$1" ]; then $HOME/.scripts/emacsclient.sh "$PWD/$1"; else $HOME/.scripts/emacsclient.sh; fi };f'

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="daveverwer"

# Environment variables
export CAREOS_LOG_FORMAT="PLAIN"
export CAREOS_ENABLE_SHUTDOWN_HOOKS="false"
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# Editor configuration
export ALTERNATE_EDITOR="nvim"
export EDITOR="nvim"
export VISUAL="nvim"

# Lazy-load NVM with bash completion
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Oh My Zsh plugins
plugins=(
  zsh-autosuggestions
  fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# FZF key bindings and completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

DISABLE_UNTRACKED_FILES_DIRTY="true"

