autoload -Uz vcs_info
autoload -Uz colors

username="%{$bg[blue]%} %m@%n %{$reset_color%}%{$bg[green]%}%{$fg[blue]%}%{$reset_color%}"
directory="%{$bg[green]%}%{$fg[white]%} %~ %{$reset_color%}%{$reset_color%}%{$bg[yellow]%}%{$fg[green]%}%{$reset_color%}"
return_code="%{$fg[black]%}%{$bg[yellow]%} %? %{$reset_color%}%{$fg_no_bold[yellow]%}%{$reset_color%}"
auth="%{$fg[black]%}%{$bg[cyan]%} %# %{$reset_color%}%{$fg[cyan]%} %{$reset_color%}"

precmd() { vcs_info }

setopt prompt_subst
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true # coomitしていないファイルのチェック
zstyle ':vcs_info:git:*' formats ' %F{white}%c%u%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{green}%b%f(%F{red}%a%f)'
zstyle ':vcs_info:git:*' max-exports 3 # メッセージ(通常、警告、エラー)のエクスポート


git_info="%{$fg[green]%} %{$reset_color%}%{$fg[black]%}%{$bg[green]%} ${vcs_info_msg_0_} %{$reset_color%}"


export PROMPT="$username$directory$return_code
$auth"

export RPROMPT="$git_info"


