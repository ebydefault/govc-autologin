GOVC_AUTOLOGIN_DIR=$(dirname "$BASH_SOURCE")

export   GOVC_AUTOLOGIN_CONF="${GOVC_AUTOLOGIN_DIR}"/govc-autologin.conf

source "$GOVC_AUTOLOGIN_CONF"
source "${GOVC_AUTOLOGIN_DIR}"/govc-autologin_bash_completion

GOVC_REAL_BIN_DIR="$(dirname "$GOVC_REAL_BIN")"
        TOOLS_DIR="$GOVC_AUTOLOGIN_DIR"/tools
         OLD_PATH="$PATH"

if [ ! -z "$GOVC_LOGGED_IN" ]; then
    # Restore the real govc priority
    export PATH="$GOVC_REAL_BIN_DIR":"$OLD_PATH"

    if [ ! -z "$GOVC_LAST_ARGS" ]; then
        govc $GOVC_LAST_ARGS  # don't double quote this argument, or it won't work!
        unset GOVC_LAST_ARGS
    fi

    if [ ! -z "$GOVC_VMID_LAST_ARGS" ]; then
        govc-vmid $GOVC_VMID_LAST_ARGS
        unset      GOVC_VMID_LAST_ARGS
    fi

    if [ ! -z "$GOVC_VMRC_LAST_ARGS" ]; then
        govc-vmrc $GOVC_VMRC_LAST_ARGS
        unset      GOVC_VMRC_LAST_ARGS
    fi
else
    # Override govc priority
    export PATH="$GOVC_AUTOLOGIN_DIR":"$TOOLS_DIR":"$OLD_PATH"
fi

# Override vmrc
export REAL_VMRC="$(which vmrc)"

alias vmrc=govc-vmrc

# vim: set syntax=bash:
