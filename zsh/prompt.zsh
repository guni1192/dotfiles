autoload -Uz colors

# ============================================================================
# Color palette — shared with tmux.conf (blue / cyan gradient)
#   navy   24   background accent
#   sky    39   secondary highlight (user/host)
#   aqua   45   mid-tone accent (git)
#   cyan   51   primary / "current" (cwd, prompt sigil)
#   ice    123  subtle informational (non-prod kube)
#   muted  244  inactive (exit 0)
# ============================================================================

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr     "%F{yellow}!"
zstyle ':vcs_info:git:*'  unstagedstr   "%F{red}+"
zstyle ':vcs_info:*'      formats       "%F{45} %b%f"
zstyle ':vcs_info:*'      actionformats "%F{45} %b%f%F{244}|%F{red}%a%f"

username="%F{39}%n@%m%f"
directory="%B%F{51} %~%f%b"
return_code="%(?|%F{244} %? %f|%F{red} %? %f)"
auth="%B%F{51}%#%f%b "

precmd () {
  vcs_info
  export kube_current_context=""
  if command -v kubectl >/dev/null 2>&1; then
    context=$(kubectl config current-context 2>/dev/null)
    if [[ -n "$context" ]]; then
      if [[ "$context" =~ .*"prd".* ]] || [[ "$context" =~ .*"production".* ]]; then
        export kube_current_context="%F{red} $context %f"
      else
        export kube_current_context="%F{123} $context %f"
      fi
    fi
  fi
}

PROMPT='$username$directory${vcs_info_msg_0_}${kube_current_context}$return_code
$auth'
