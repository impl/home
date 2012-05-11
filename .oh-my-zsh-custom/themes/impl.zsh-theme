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
        background_jobs=${(ej:%{${reset_color}%} %{${fg[magenta]}%}:)background_jobs}
        background_jobs=${background_jobs:+" %{$fg[magenta]%}${background_jobs} ⚡%{$reset_color%}"}
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
            rendered_username="%{$bold_color%}%{$fg[yellow]%}(%n)%{$reset_color%}"
        else
            rendered_username="(%n)"
        fi
        ;;
esac

if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    # Display exit code when necessary
    return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

    PROMPT='%{$fg[yellow]%}➠%{$reset_color%} %{$bold_color%}%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info)${emacs_prompt}
%(!.%{$bold_color%}%{$fg[red]%}.%{$fg[green]%})%m%{$reset_color%}${rendered_username} %(!.%{$bold_color%}%{$fg[red]%}.%{$fg[yellow]%})%#%{$reset_color%} '

    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}➠%{$reset_color%} %{$fg[cyan]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%} %{$fg[blue]%}✓%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%} %{$fg[red]%}✗%{$reset_color%}"

    RPROMPT='${return_code}${background_jobs}$(git_prompt_status)%{$reset_color%}'

    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
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
