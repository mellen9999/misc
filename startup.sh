#!/bin/bash

# dbus initialization
[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && eval "$(dbus-launch --sh-syntax --exit-with-session)"

# display configuration
wlr-randr --output DP-3 --mode 1920x1080@498.932007Hz || {
    echo "falling back to preferred mode" >&2
    wlr-randr --output DP-3 --preferred
}

# audio pipeline
gentoo-pipewire-launcher start || {
    echo "pipewire start failed - direct start" >&2
    pipewire &
    pipewire-pulse &
    wireplumber &
}

# background services
/usr/libexec/dconf-service &
/usr/libexec/xdg-permission-store &

# wayland compatibility
export XDG_CURRENT_DESKTOP=sway
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1

# session persistence
exec sleep infinity
