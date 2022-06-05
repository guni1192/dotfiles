autoload -Uz colors

username="%F{black}%K{cyan} %n@%m %b%k"
directory="%F{black}%K{green} %~ %b%k"
return_code="%F{black}%K{white} %? %b%k"
auth="%F{white}%K{black}%# %b%k"

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
zstyle ':vcs_info:*'      formats       "%F{black}%K{white} > %b %k"
zstyle ':vcs_info:*'      actionformats '%b|%a'

precmd () {
  vcs_info
}

PROMPT="$username$directory$return_code
$auth"

RPROMPT='${vcs_info_msg_0_}'
