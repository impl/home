#! /usr/bin/env zsh -f
# -*- mode: sh -*-

# Find out background jobs
impl_theme_precmd() {
    background_jobs=()
    for job (${(k)jobstates}); do
        state=$jobstates[$job]
        running=${${(@s,:,)state}[2]}
        background_jobs+=("${job}${running//[^+-]/}")
    done

    if [[ $TERM != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
        background_jobs=${(ej:%{${reset_color}%} %{${FG[138]}%}:)background_jobs}
        background_jobs=${background_jobs:+" %{$FG[138]%}${background_jobs} ⚡%{$reset_color%}"}
    else
        background_jobs=${(j:,:)background_jobs}
        background_jobs=${background_jobs:+" ${background_jobs} ⚡"}
    fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd impl_theme_precmd

# If we're in Emacs, set some extra variables accordingly
emacs_prompt=
case "$TERM" in
    eterm|eterm-*)
        ssh_port=
        if [ ! -z "${SSH_CONNECTION}" ]; then
            ssh_port="#${SSH_CONNECTION[(w)-1]}"
        fi

        impl_theme_emacs_precmd() {
            emacs_prompt="%{"$'\eAnSiTu'"%}%n%{"$'\0'"%}"
            emacs_prompt+="%{"$'\eAnSiTh'"%}%M${ssh_port}%{"$'\0'"%}"
            emacs_prompt+="%{"$'\eAnSiTc'"%}%d%{"$'\0'"%}"
        }

        add-zsh-hook precmd impl_theme_emacs_precmd
        ;;
esac

rendered_username=
case "$USERNAME" in
    Noah|nfontes)
        ;;
    *)
        if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
            rendered_username="%{$bold_color%}%{$FG[230]%}(%n)%{$reset_color%}"
        else
            rendered_username="(%n)"
        fi
        ;;
esac

if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    # Display exit code when necessary
    return_code="%(?..%{$FG[161]%}%? ↵%{$reset_color%})"

    PROMPT='%{$FG[230]%}➠%{$reset_color%} %{$bold_color%}%{$FG[037]%}%~%{$reset_color%}$(git_prompt_info)${emacs_prompt}
%(!.%{$bold_color%}%{$FG[161]%}.%{$FG[120]%})%m%{$reset_color%}${rendered_username} %(!.%{$bold_color%}%{$FG[161]%}.%{$FG[230]%})%#%{$reset_color%} '

    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[230]%}➠%{$reset_color%} %{$FG[077]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%} %{$FG[037]%}✓%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%} %{$FG[161]%}✗%{$reset_color%}"

    RPROMPT='${return_code}${background_jobs}$(git_prompt_status)%{$reset_color%}'

    ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[120]%} ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[037]%} ✹"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[161]%} ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[138]%} ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[230]%} ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[077]%} ✭"
else
    # Display exit code when necessary
    return_code="%(?..%? ↵)"

    PROMPT='➠ %~$(git_prompt_info)${emacs_prompt}
%m${rendered_username} %# '

    ZSH_THEME_GIT_PROMPT_PREFIX=" ➠ "
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_CLEAN=" ✓"
    ZSH_THEME_GIT_PROMPT_DIRTY=" ✗"

    RPROMPT='${return_code}${background_jobs}$(git_prompt_status)'

    ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
    ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
fi
