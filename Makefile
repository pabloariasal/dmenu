all: dmenu/dmenu

dmenu/dmenu: dmenu libxft/src/.libs/libXft.a
	make -C $<

dmenu:
	git clone --branch 5.0 https://git.suckless.org/dmenu
	patch -d $@ < color_emojis.patch
	patch -d $@ < dmenu-gruvbox-20210329-9ae8ea5.diff
	patch -d $@ < vim_bindings.patch
	patch -d $@ < dmenu-caseinsensitive-5.0.diff

libxft/src/.libs/libXft.a: libxft
	cd $< && ./autogen.sh && make SUBDIRS=src

libxft: libxft-bgra.patch
	git clone https://gitlab.freedesktop.org/xorg/lib/libxft.git
	@# Remove check for xorg-util-macros that's only used to add `.1` at the
	@# end of a man page we're not gonna use.
	patch -d $@ < libxft.patch
	patch -d $@ -p1 < $<

libxft-bgra.patch:
	curl -o $@ https://gitlab.freedesktop.org/xorg/lib/libxft/-/merge_requests/1.patch

install: dmenu/dmenu
	make -C dmenu install

clean:
	rm -rf dmenu
