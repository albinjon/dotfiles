switch (uname)
    case Linux
        set -gx DOTNET_ROOT /opt/homebrew/share/dotnet
        set -gx DOTNET_ROOT_ARM64 /opt/homebrew/share/dotnet
        /usr/bin/mise activate fish | source


    case Darwin
        set -gx DOTNET_ROOT /opt/homebrew/share/dotnet
        set -gx DOTNET_ROOT_ARM64 /opt/homebrew/share/dotnet
        set -gx GOROOT $(/opt/homebrew/bin/brew  --prefix go)/libexec
        set -gx GOPATH $HOME/go
        set -gx PNPM_HOME $HOME/Library/pnpm
        eval (/opt/homebrew/bin/brew shellenv)
        function sketch
            nohup sketchybar >/dev/null 2>&1 &
        end
        ~/.local/bin/mise activate fish | source

    case '*'
            echo Hi, stranger!
end

if test -f $HOME/.secret_envs/credentials.fish
    source $HOME/.secret_envs/credentials.fish
end

set -gx FLYCTL_INSTALL /home/albin/.fly
set -U fish_user_paths $HOME/bin $HOME/.deno/bin  $HOME/Programmering/apps $HOME/.local/bin $HOME/.local/bin/nvim/bin $HOME/.config/emacs/bin $GOPATH/bin $GOROOT/bin $FLYCTL_INSTALL/bin $HOME/.rbenv/bin /usr/local/bin $HOME/.jenv/bin:$PATH $HOME/.dotnet/tools $HOME/.bun/bin $HOME/bin $PNPM_HOME $fish_user_paths

set fzf_fd_opts --hidden --follow -E .git -E node_modules -E .venv -E venv/ -E .cache -E .DS_Store -E /Music -E /Library -E /Applications -E .npm/ -E .docker/ -E .cursor/ -E .local/ -E Movies/ -E .vscode/ -E go/pkg -E .pyenv/ -E Pictures/ -E .prettierd/ -E .pgadmin/ -E .runelite/

fzf_configure_bindings --directory=\cf --processes=\cp
set -U fish_greeting

set -gx PYENV_ROOT $HOME/.pyenv

set -gx XDG_CONFIG_HOME $HOME/.config
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

alias gw='./gradlew'
alias gwf='./gradlew ktlintFormat'
alias gwt='./gradlew test'
alias gwit='./gradlew integrationTest'
alias gwc='./gradlew check'

alias k "kubectl"

alias va "source .venv/bin/activate.fish"
alias da "deactivate"

function measure_command_time
    if test (count $argv) -lt 2
        echo "Usage: measure_command_time 'your command' 'log message to search for'"
        return 1
    end

    set command $argv[1]
    set log_message $argv[2]

    node /Users/albin/.scripts/measure_command_time.js $command $log_message
end

function nvim
    set -l f (set -q TMPDIR; and echo $TMPDIR/nvim_cwd; or echo /tmp/nvim_cwd)
    command nvim $argv
    and test -s $f
    and eval (cat $f)
    and rm -f $f
end


alias lower "tr '[:upper:]' '[:lower:]'"
alias strip "tr -d '\n'"
alias uuid "uuidgen | lower | strip | pbcopy"
alias resketch "sketchybar --reload"
# alias pip "pip3"
alias chx "chmod +x"
alias py "python3"

alias ll="nnn_cd -dex"

zoxide init --cmd j fish | source

if test -f ~/.local/share/google-cloud-sdk/path.fish.inc
    source ~/.local/share/google-cloud-sdk/path.fish.inc
end
