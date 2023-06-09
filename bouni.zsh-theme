# Bouni theme for oh-my-zsh
# based on Oxide theme for Zsh
#
# Author: Bouni <bouni-github@owee.de>
# Repository: https://github.com/bouni/bouni-zsh-theme
#
# Oxide Author: Diki Ananta <diki1aap@gmail.com>
# Oxide Repository: https://github.com/dikiaap/dotfiles
# License: MIT

# Prompt:
# %F => Color codes
# %f => Reset color
# %~ => Current path
# %(x.true.false) => Specifies a ternary expression
#   ! => True if the shell is running with root privileges
#   ? => True if the exit status of the last command was success
#
# Git:
# %a => Current action (rebase/merge)
# %b => Current branch
# %c => Staged changes
# %u => Unstaged changes
#
# Terminal:
# \n => Newline/Line Feed (LF)

setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Use True color (24-bit) if available.
if [[ "${terminfo[colors]}" -ge 256 ]]; then
    oxide_turquoise="%F{75}"
    oxide_orange="%F{208}"
    oxide_red="%F{167}"
    oxide_limegreen="%F{112}"
    oxide_pink="%F{198}"
else
    oxide_turquoise="%F{cyan}"
    oxide_orange="%F{yellow}"
    oxide_red="%F{red}"
    oxide_limegreen="%F{green}"
fi

# Reset color.
oxide_reset_color="%f"

# VCS style formats.
FMT_UNSTAGED="%{$oxide_reset_color%} %{$oxide_orange%}✗"
FMT_STAGED="%{$oxide_reset_color%} %{$oxide_limegreen%}✓"
FMT_ACTION="(%{$oxide_limegreen%}%a%{$oxide_reset_color%})"
FMT_VCS_STATUS="on %{$oxide_turquoise%} %b%u%c%{$oxide_reset_color%}"

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_VCS_STATUS} ${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
zstyle ':vcs_info:*' nvcsformats    ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# Check for untracked files.
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep --max-count=1 '^??' &> /dev/null; then
        hook_com[staged]+="%{$oxide_reset_color%} %{$oxide_red%}✗"
    fi
}

# Executed before each prompt.
add-zsh-hook precmd vcs_info

FMT_USER="%{$oxide_orange%}%n%{$oxide_reset_color%}"
FMT_HOST="%{$oxide_pink%}%m%{$oxide_reset_color%}"
USER_HOST="%{$FMT_USER%}%F{white}@%{$oxide_reset_color%}%{$FMT_HOST%}"

FMT_DIR="%{$oxide_limegreen%}%~%{$oxide_reset_color%}"

FMT_RETURN_VALUE="%(?.%{%F{white}%}.%{$oxide_red%})%(!.#.❯)%{$oxide_reset_color%}"

# Oxide prompt style.
PROMPT=$'%{$USER_HOST%} ❯ %{$FMT_DIR%} ❯ ${vcs_info_msg_0_}\n%{$FMT_RETURN_VALUE%} '
