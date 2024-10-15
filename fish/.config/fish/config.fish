set -U fish_user_paths $HOME/bin $HOME/.deno/bin /usr/local/bin $HOME/Programmering/apps $HOME/.local/bin $HOME/.local/bin/nvim/bin $HOME/.config/emacs/bin $fish_user_paths

set fzf_fd_opts --hidden

fzf_configure_bindings --directory=\cg --processes=\cp

set -U fish_greeting

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

# Other aliases
function sketch
    nohup sketchybar >/dev/null 2>&1 &
end
alias resketch "sketchybar --reload"
alias pip "pip3"
alias chx "chmod +x"
alias py "python3"

if status is-interactive
    # Commands to run in interactive sessions can go here
end
