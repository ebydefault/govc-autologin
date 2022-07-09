source ./govc-autologin.conf
source ${HOME}/bin/govc-autologin/govc-autologin_bash_completion

OLD_PATH="$PATH"
GOVC_REAL_BIN_PATH="$(dirname "$GOVC_REAL_BIN")"

if [ -n "$GOVC_LOGGED_IN" ]; then
    # Restore the real govc priority
    export PATH="$GOVC_REAL_BIN_PATH":"$OLD_PATH"

    if [ -n "$GOVC_LAST_ARGS" ]; then
        govc $GOVC_LAST_ARGS  # don't double quote this argument, or it won't work!
        unset GOVC_LAST_ARGS
    fi
else
    # Override govc priority
    export PATH="$PWD":"$OLD_PATH"
fi
