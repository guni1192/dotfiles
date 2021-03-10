autoload -Uz colors

username="%{$fg[white]%}%{$bg[blue]%} %n@%m %{$reset_color%}%{$bg[white]%}%{$fg[blue]%}%{$reset_color%}"
directory="%{$bg[white]%}%{$fg[black]%} %~ %{$reset_color%}%{$reset_color%}%{$bg[black]%}%{$fg[white]%}%{$reset_color%}"
date="%{$fg[white]%}%{$bg[black]%} %D %{$reset_color%}%{$fg[black]%} %{$reset_color%}"
return_code="%{$fg[white]%}%{$bg[black]%}  %?  %{$reset_color%}%{$fg_no_bold[black]%}%{$reset_color%}"
auth="%{$fg[black]%}%{$bg[white]%}  %#  %{$reset_color%}%{$fg[white]%} %{$reset_color%}"

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
zstyle ':vcs_info:*'      formats       "%{${fg[black]}%}%{${fg[white]}${bg[black]}%} %b %{$reset_color%}"
zstyle ':vcs_info:*'      actionformats '%b|%a'

precmd () {
  vcs_info
}

PROMPT="$username$directory$return_code
$auth"

RPROMPT='${vcs_info_msg_0_}'
