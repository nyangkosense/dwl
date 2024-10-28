## dwl - dwm for wayland custom ver.

![20241024_16h36m07s_grim](https://github.com/user-attachments/assets/32700f17-268a-414d-909d-f9944453acda)


- custom (patched) version of dwl. 
- patches applied see patches/
- requires dwlb for bar and dmenu_wl for dmenu wayland version
- the other branch holds the patched in bar patch. However, i only got status working with slstatus (which has no colors and options like dwlb)
- furthermore there are not that many patches for it yet. 


## custom patches (from dwm to dwl)
- the cycle layout patch that i ported form dwm to dwl also is included: - https://github.com/nyangkosense/dwl/blob/main/patches/custom_patches/cyclelayout.patch
  
### Makefile and config.mk 

- due to wlroots versions and pixman, config.mk and makefile changed

