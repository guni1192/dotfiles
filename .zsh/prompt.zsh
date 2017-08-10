autoload -Uz colors

username="%{$bg[blue]%} %m@%n %{$reset_color%}%{$bg[green]%}%{$fg[blue]%}%{$reset_color%}"
directory="%{$bg[green]%}%{$fg[black]%} %~ %{$reset_color%}%{$reset_color%}%{$bg[yellow]%}%{$fg[green]%}%{$reset_color%}"
return_code="%{$fg[black]%}%{$bg[yellow]%} %? %{$reset_color%}%{$fg_no_bold[yellow]%}%{$reset_color%}"
auth="%{$fg[black]%}%{$bg[cyan]%} %# %{$reset_color%}%{$fg[cyan]%} %{$reset_color%}"


autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
# zstyle ':vcs_info:*'      formats       "%{'$fg[red]%}''$bg[white]}'%c%u%b%f}"
zstyle ':vcs_info:*'      formats       "%{${fg[black]}%}%{${fg[red]}${bg[black]}%} %b %{$reset_color%}"
zstyle ':vcs_info:*'      actionformats '%b|%a'

precmd () {
  if [ -n "$VIRTUAL_ENV" ]; then
    venv_value=`basename $VIRTUAL_ENV`
    VENV="%{$fg[black]%}%{$bg[red]%} $venv_value %{$reset_color%}%{$bg[cyan]%}%{$fg[red]%}%{$reset_color%}"
  else
    VENV=""
  fi
  vcs_info
}

RPROMPT='${vcs_info_msg_0_}'

PROMPT="$username$directory$return_code
$VENV$auth"


