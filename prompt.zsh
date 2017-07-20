autoload -Uz vcs_info
autoload -Uz colors

export PROMPT="%{$bg[blue]%} %m @ %n %{$reset_color%}%{$fg[blue]%}%{$reset_color%}%{$bg[yellow]%}%{$fg[black]%} %~ %{$reset_color%}%{$fg[yellow]%}%{$reset_color%}
%{$fg[blue]%}%# %{$reset_color%}"


export RPROMPT

