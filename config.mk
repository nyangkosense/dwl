# Version
_VERSION = 0.8-dev
VERSION = `git describe --tags --dirty 2>/dev/null || echo $(_VERSION)`

PKG_CONFIG = pkg-config

# paths
PREFIX = /usr/local
MANDIR = $(PREFIX)/share/man
DATADIR = $(PREFIX)/share

# Wlroots configuration
WLR_INCS = -I/usr/include/pixman-1 -I/usr/include/libdrm \
    -I/home/seb/dwl/wlroots/build/prefix/include/wlroots-0.19

WLR_LIBS = -Wl,-rpath,/home/seb/dwl_project/dwl/wlroots/build \
    -L/home/seb/dwl/wlroots/build -lwlroots-0.19

# Add fcft to the base packages
PKGS = wayland-server xkbcommon libinput pixman-1 fcft $(XLIBS)

# If pkg-config doesn't work for fcft, you might need to add it explicitly:
LIBS += -lfcft -lpixman-1

XWAYLAND =
XLIBS =

# Default compiler
CC = cc