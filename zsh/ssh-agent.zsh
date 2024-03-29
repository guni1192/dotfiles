agent="$HOME/.ssh/agent"

if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" $agent && \
            export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "ssh-agent not fonud"
fi
