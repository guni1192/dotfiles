autoload -Uz colors

username="%{$fg[white]%}%{$bg[blue]%} %m@%n %{$reset_color%}%{$bg[white]%}%{$fg[blue]%}%{$reset_color%}"
directory="%{$bg[white]%}%{$fg[black]%} %~ %{$reset_color%}%{$reset_color%}%{$bg[black]%}%{$fg[white]%}%{$reset_color%}"
date="%{$fg[white]%}%{$bg[black]%} %D %{$reset_color%}%{$fg[black]%} %{$reset_color%}"
return_code="%{$fg[black]%}%{$bg[white]%}  %?  %{$reset_color%}%{$fg_no_bold[white]%}%{$bg[black]%}%{$reset_color%}"
auth="%{$fg[white]%}%{$bg[black]%}  %#  %{$reset_color%}%{$fg[black]%} %{$reset_color%}"

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
# zstyle ':vcs_info:*'      formats       "%{'$fg[red]%}''$bg[white]}'%c%u%b%f}"
zstyle ':vcs_info:*'      formats       "%{${fg[black]}%}%{${fg[white]}${bg[black]}%} %b %{$reset_color%}"
zstyle ':vcs_info:*'      actionformats '%b|%a'

export VIRTUAL_ENV_DISABLE_PROMPT=1
precmd () {
  if [ -n "$VIRTUAL_ENV" ]; then
    venv_value=`basename $VIRTUAL_ENV`
    VENV="%{$fg[black]%}%{$bg[green]%} $venv_value %{$reset_color%}%{$bg[yellow]%}%{$fg[green]%}%{$reset_color%}"
  else
    VENV=""
  fi
  vcs_info
}

PROMPT="$username$directory$date
$VENV$return_code$auth"

RPROMPT='${vcs_info_msg_0_}'
