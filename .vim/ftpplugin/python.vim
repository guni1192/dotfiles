python << EOF
import os
import sys

path = os.path.expanduser("~/.pyenv/versions/anaconda3-2.5.0/lib/python3.5/hite-packages")
if not path in sys.path:
    sys.path.append(path)
EOF