autoload -Uz colors

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
zstyle ':vcs_info:*'      formats       "%F{green} %b%k"
zstyle ':vcs_info:*'      actionformats '%b|%a'

username="%F{blue}%n@%m%b%k"
directory="%F{cyan} %~%b%k"
return_code="%F{white} %? %b%k"
auth="%F{white}%# %b%k"

precmd () {
  vcs_info
  export kube_current_context=""
  if command -v kubectl >/dev/null 2>&1; then
    context=$(kubectl config current-context 2>/dev/null)
    if [[ -n "$context" ]]; then
      if [[ "$context" =~ .*"prd".* ]] || [[ "$context" =~ .*"production".* ]]; then
        export kube_current_context="%F{red} $context %b%k"
      else
        export kube_current_context="%F{yellow} $context %b%k"
      fi
    fi
  fi
}

# RPROMPT='${vcs_info_msg_0_}'

PROMPT='$username$directory${vcs_info_msg_0_}${kube_current_context}$return_code
$auth'
