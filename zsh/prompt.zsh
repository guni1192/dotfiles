autoload -Uz colors


autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
zstyle ':vcs_info:*'      formats       "%F{black}%K{white} > %b %k"
zstyle ':vcs_info:*'      actionformats '%b|%a'

GIT_CONFIG_USER_NAME=$(git config --get user.name)
GIT_CONFIG_USER_EMAIL=$(git config --get user.email)
GIT_USER="%F{white}%K{gray} ${GIT_CONFIG_USER_NAME}<${GIT_CONFIG_USER_EMAIL}> %b%k"

username="%F{black}%K{cyan} %n@%m %b%k"
directory="%F{black}%K{green} %~ %b%k"
return_code="%F{black}%K{white} %? %b%k"
auth="%F{white}%K{black}%# %b%k"

precmd () {
  vcs_info
}

PROMPT="$username$directory$GIT_USER$return_code
$auth"

RPROMPT='${vcs_info_msg_0_}'
