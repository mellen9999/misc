#!/bin/bash
# Initialize D-Bus environment
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
    export DBUS_SESSION_BUS_ADDRESS
fi

# Set display mode
wlr-randr --output DP-3 --mode 1920x1080@498.932007Hz || {
    echo "Falling back to preferred mode" >&2
    wlr-randr --output DP-3 --preferred
}

# Start PipeWire with proper D-Bus integration
gentoo-pipewire-launcher start || {
    echo "PipeWire start failed - attempting direct start" >&2
    pipewire &
    pipewire-pulse &
    wireplumber &
}

# Start D-Bus-activated services
/usr/libexec/dconf-service &
/usr/libexec/xdg-permission-store &

# Ensure Spotify can access D-Bus
export XDG_CURRENT_DESKTOP=sway  # Many apps expect this
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1

# Keep session alive
exec sleep infinity
