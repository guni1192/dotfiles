# Re-apply brew shellenv after /etc/zprofile runs path_helper, which would
# otherwise push /opt/homebrew/bin behind /usr/bin in PATH.
case ${OSTYPE} in
    darwin*)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ;;
esac

export GPG_TTY=$(tty)

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
