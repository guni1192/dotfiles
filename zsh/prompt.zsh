autoload -Uz colors

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
zstyle ':vcs_info:*'      formats       "%F{black}%K{green} > %b %k"
zstyle ':vcs_info:*'      actionformats '%b|%a'

username="%F{white}%K{blue} %n@%m %b%k"
directory="%F{black}%K{cyan} %~ %b%k"
return_code="%F{black}%K{white} %? %b%k"
auth="%F{white}%K{black}%# %b%k"

precmd () {
  vcs_info
}

# RPROMPT='${vcs_info_msg_0_}'

PROMPT='$username$directory${vcs_info_msg_0_}$return_code
$auth'
