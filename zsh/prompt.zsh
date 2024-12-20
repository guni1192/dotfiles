autoload -Uz colors

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
zstyle ':vcs_info:*'      formats       "%F{green} %b%k"
zstyle ':vcs_info:*'      actionformats '%b|%a'

username="%F{blue}%K{black}%n@%m%b%k"
directory="%F{cyan}%K{black} %~%b%k"
return_code="%F{white}%K{black} %? %b%k"
auth="%F{white}%K{black}%# %b%k"

precmd () {
  vcs_info
  export kube_current_context=""
  context=$(kubectl config current-context)
  if [[ "$context" =~ .*"prd".* ]] || [[ "$context" =~ .*"production".* ]]; then
      export kube_current_context="%F{red}%K{black} $context %b%k"
  else
      export kube_current_context="%F{yellow}%K{black} $context %b%k"
  fi
}

# RPROMPT='${vcs_info_msg_0_}'

PROMPT='$username$directory${vcs_info_msg_0_}${kube_current_context}$return_code
$auth'
