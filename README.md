## dwl - dwm for wayland custom ver.

![20241024_16h27m36s_grim](https://github.com/user-attachments/assets/fdf2ee11-6f3a-48d6-870d-07051429a1ac)

- custom (patched) version of dwl. 
- patches applied see patches/
- requires dwlb for bar and dmenu_wl for dmenu wayland version
- the other branch holds the patched in bar patch. However, i only got status working with slstatus (which has no colors and options like dwlb)
- furthermore there are not that many patches for it yet. 

### Makefile and config.mk 

- due to wlroots versions and pixman, config.mk and makefile changed

