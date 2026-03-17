# config for the Zoomer Shell

# Enable colors and change prompt:

setopt PROMPT_SUBST


CURRENT_BG='NONE'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='3';;
    *)     CURRENT_FG='0';;
esac

# Special Powerline characters

() {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    # NOTE: This segment separator character is correct.  In 2012, Powerline changed
    # the code points they use for their special characters. This is the new code point.
    # If this is not working for you, you probably have an old version of the
    # Powerline-patched fonts installed. Download and install the new version.
    # Do not submit PRs to change this unless you have reviewed the Powerline code point
    # history and have new information.
    # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
    # what font the user is viewing this source code in. Do not replace the
    # escape sequence with a single literal character.
    # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
    SEGMENT_SEPARATOR=$'\ue0b0' # 
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
    local bg fg
    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
        echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
    else
        echo -n "%{$bg%}%{$fg%} "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && echo -n "$3"
}

# End the prompt, closing any open segments
prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
        echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
    else
        echo -n "%{%k%}"
    fi
    echo -n "%{%f%}"
    CURRENT_BG='NONE'
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
        prompt_segment 237 7 "%(!.%{%F{3}%}.)%n@%m"
    fi
}


# Dir: current working directory
prompt_dir() {
    prompt_segment 4 $CURRENT_FG '%1~'
}

# Git: current branch and status
prompt_git() {
    (( $+commands[git] )) || return
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    local branch ahead behind
    local staged=0
    local unstaged=0
    local untracked=0
    local mode=""
    local git_dir
    local line
    local git_symbol

    git_dir=$(git rev-parse --git-dir 2>/dev/null) || return
    git_symbol=""

    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) \
        || branch="$(git rev-parse --short HEAD 2>/dev/null)" \
        || return

    if [[ -e "${git_dir}/BISECT_LOG" ]]; then
        mode=" <B>"
    elif [[ -e "${git_dir}/MERGE_HEAD" ]]; then
        mode=" >M<"
    elif [[ -d "${git_dir}/rebase-merge" || -d "${git_dir}/rebase-apply" ]]; then
        mode=" >R>"
    fi

    while IFS= read -r line; do
        [[ "${line:0:2}" == "??" ]] && ((untracked=1)) && continue
        [[ "${line:0:1}" != " " ]] && ((staged=1))
        [[ "${line:1:1}" != " " ]] && ((unstaged=1))
    done < <(git status --porcelain 2>/dev/null)

    local -i ahead=0
    local -i behind=0

    if git rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>&1; then
        local counts
        counts=$(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)

        if [[ -n "$counts" ]]; then
            ahead=${counts%%[[:space:]]*}
            behind=${counts##*[[:space:]]}
        fi
    fi

    local -a parts
    parts+=("${git_symbol} ${branch}")

    (( unstaged ))  && parts+=("●")
    (( staged ))    && parts+=("✚")
    (( untracked )) && parts+=("?")
    (( ahead ))     && parts+=("↑")
    (( behind ))    && parts+=("↓")
    [[ -n "$mode" ]] && parts+=("${mode}")

    if (( unstaged || staged || untracked )); then
        prompt_segment 3 0 "${(j: :)parts}"
    else
        prompt_segment 2 $CURRENT_FG "${(j: :)parts}"
    fi
}

# Virtualenv: current working virtualenv
# Show the actual venv directory name (for named venvs)
# If it is ".venv" show parent directory (for project-local venvs)
export VIRTUAL_ENV_DISABLE_PROMPT=1
prompt_virtualenv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name
        venv_name="${VIRTUAL_ENV:t}"

        if [[ "$venv_name" == ".venv" || "$venv_name" == "venv" ]]; then
            venv_name="${VIRTUAL_ENV:h:t}"
        fi

        prompt_segment 237 4 "(${venv_name})"
        #prompt_segment 2 0 "(${venv_name})"
    fi
}

# Status:
# - was there an error
# - am I root - still have to edit roots zshrc
# - are there background jobs?
prompt_status() {
    local -a symbols
    local ret=$1

    [[ $ret -ne 0 ]] && symbols+=("%{%F{1}%}\u2718") #✘
    [[ $UID -eq 0 ]] && symbols+=("%{%F{11}%}\u26a1") #⚡ - still have to edit roots zshrc
    (( ${#jobstates} > 0 )) && symbols+=("%{%F{15}%}\u26ef") #⛯

    (( ${#symbols[@]} )) && prompt_segment 237 7 "${(j: :)symbols}"
}

## Main prompt
build_prompt() {
    local ret=$?
    CURRENT_BG='NONE'
    prompt_status "$ret"
    prompt_virtualenv
    prompt_context
    prompt_dir
    prompt_git
    prompt_end
}


autoload -U colors && colors
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%1~%{$fg[red]%}]%{$reset_color%}$%b$(build_prompt) "
PROMPT='$(build_prompt) '
RPROMPT='%*'

# export CATALINA_HOME=/home/me/IdeaProjects/apache-tomcat-9.0.33

# History in cache directory:
HISTSIZE=100000
SAVEHIST=100000
mkdir -p ~/.cache/zsh
HISTFILE=~/.cache/zsh/history

# Set Options
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt APPEND_HISTORY            # Append to the history file, don't overwrite it.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Don't display a line previously found.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.


# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:*:git:*' script ~/.config/zsh/git-completion.bash
fpath=(~/.config/zsh $fpath)
zmodload zsh/complist
compinit -d ~/.cache/zsh/zcompdump
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1
bindkey "^R" history-incremental-search-backward
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
zle-keymap-select() {
    if [[ $KEYMAP == vicmd || $1 == block ]]; then
        printf '\e[1 q'
    elif [[ $KEYMAP == main || $KEYMAP == viins || -z $KEYMAP || $1 == beam ]]; then
        printf '\e[5 q'
    fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    printf '\e[5 q'
}
zle -N zle-line-init

preexec() { printf '\e[5 q' }

# Use ranger to switch directories and bind it to ctrl-o
rangercd() {
    local tmpfile="$HOME/.cache/ranger/rangerdir"
    ranger --choosedir="$tmpfile"
    [[ -f "$tmpfile" ]] || return
    local lastdir
    lastdir=$(<"$tmpfile")
    [[ -d "$lastdir" && "$lastdir" != "$PWD" ]] && cd "$lastdir"
}
bindkey -s '^o' 'rangercd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# AIssistant
# Suggest a single shell command
cs() {
    local query="$*"
    [[ -z "$query" ]] && {
        print -u2 -- "usage: cs <what you want to do>"
        return 2
    }

    printf '%s\n' "You are a shell assistant.
Return exactly one best zsh/bash command for the user's request.
Rules:
- Output only the command, no markdown, no backticks, no explanation.
- Prefer safe, non-destructive commands.
- Preserve placeholders like <file>, <dir>, <pattern> when needed.
User request: $query" \
    | claude -p --output-format text --tools ""
}

# Explain a shell command
ce() {
    local cmd="$*"
    [[ -z "$cmd" ]] && {
        print -u2 -- "usage: ce <command>"
        return 2
    }

    printf '%s\n' "Explain this shell command for an experienced developer.
Rules:
- Be concise but complete.
- Break down pipes, flags, globs, redirects, subshells, and quoting.
- Mention dangerous parts clearly.
Command: $cmd" \
    | claude -p --output-format text --tools ""
}

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"
source ~/.shortcuts
# enable fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
# fish like suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/nvm/init-nvm.sh
