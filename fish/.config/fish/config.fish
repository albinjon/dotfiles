eval (/opt/homebrew/bin/brew shellenv)
 
set -U fish_user_paths $HOME/bin $HOME/.deno/bin /usr/local/bin $HOME/Programmering/apps $HOME/.local/bin $HOME/.local/bin/nvim/bin $HOME/.config/emacs/bin $fish_user_paths

set fzf_fd_opts --hidden --follow -E .git -E node_modules -E .venv -E venv/ -E .cache -E .DS_Store -E /Music -E /Library -E /Applications -E .npm/ -E .docker/ -E .cursor/ -E .local/ -E Movies/ -E .vscode/ -E go/pkg -E .pyenv/ -E Pictures/ -E .prettierd/ -E .pgadmin/ -E .runelite/

fzf_configure_bindings --directory=\cg --processes=\cp
set -U nvm_default_version v20.18.0
set -U fish_greeting

set -gx PYENV_ROOT $HOME/.pyenv

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx CAREOS_LOG_FORMAT PLAIN
set -gx CAREOS_ENABLE_SHUTDOWN_HOOKS false
set -gx ALTERNATE_EDITOR nvim
set -gx EDITOR nvim
set -gx VISUAL nvim

# Git aliases
alias gcam "git commit -am"
alias gco "git checkout"
alias gp "git push"
alias gpl "git pull"
alias gaa "git add -A"
alias gpo "git push -u origin"
alias gs "git status"
alias gst "git stash"
alias gstp "git stash pop"
alias gmm "git merge main"
alias gsw "git switch -"
alias gd "git diff"

# Import secrets
source $HOME/.secret_envs/.env

bind \es 'cd ~/careos-backend && npm run cos; commandline -f repaint'

# Other aliases
function sketch
    nohup sketchybar >/dev/null 2>&1 &
end

function measure_command_time
    if test (count $argv) -lt 2
        echo "Usage: measure_command_time 'your command' 'log message to search for'"
        return 1
    end

    set command $argv[1]
    set log_message $argv[2]

    node /Users/albin/.scripts/measure_command_time.js $command $log_message
end
alias lower "tr '[:upper:]' '[:lower:]'"
alias strip "tr -d '\n'"
alias uuid "uuidgen | lower | strip | pbcopy"
alias resketch "sketchybar --reload"
alias pip "pip3"
alias chx "chmod +x"
alias py "python3"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Added by Windsurf
fish_add_path /Users/albin/.codeium/windsurf/bin
