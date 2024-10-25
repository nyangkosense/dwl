_VERSION = 0.8-dev
VERSION  = `git describe --tags --dirty 2>/dev/null || echo $(_VERSION)`
PKG_CONFIG = pkg-config

# paths
PREFIX = /usr/local
MANDIR = $(PREFIX)/share/man
DATADIR = $(PREFIX)/share

# Configure wlroots paths
WLR_INCS = -I/usr/include/pixman-1 -I/usr/include/libdrm \
    -I/home/seb/dwl/wlroots/build/prefix/include/wlroots-0.19

WLR_LIBS = -Wl,-rpath,/home/seb/dwl_project/dwl/wlroots/build \
    -L/home/seb/dwl/wlroots/build -lwlroots-0.19

# Basic X11 libs
XWAYLAND =
XLIBS =

# Using cc for C11 support
CC = cc
