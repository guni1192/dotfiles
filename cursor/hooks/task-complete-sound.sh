#!/bin/bash
set -euo pipefail

input=$(cat)
if ! echo "$input" | grep -qE '"status"[[:space:]]*:[[:space:]]*"completed"'; then
    exit 0
fi

case "$(uname -s)" in
    Darwin)
        afplay /System/Library/Sounds/Hero.aiff &
        ;;
    Linux)
        if command -v paplay >/dev/null 2>&1; then
            paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &
        fi
        ;;
esac

exit 0
