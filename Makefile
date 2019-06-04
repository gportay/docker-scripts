#
# Copyright (c) 2017-2019 Gaël PORTAY
#
# SPDX-License-Identifier: MIT
#

PREFIX ?= /usr/local

.PHONY: all
all:

.PHONY: doc
doc: docker-clean.1.gz docker-archive.1.gz

.PHONY: install-all
install-all: install install-doc install-bash-completion

.PHONY: install
install:
	install -d $(DESTDIR)$(PREFIX)/bin/
	install -m 755 docker-clean docker-archive $(DESTDIR)$(PREFIX)/bin/

.PHONY: install-doc
install-doc:
	install -d $(DESTDIR)$(PREFIX)/share/man/man1/
	install -m 644 docker-clean.1.gz \
	               docker-archive.1.gz \
	           $(DESTDIR)$(PREFIX)/share/man/man1/

.PHONY: install-bash-completion
install-bash-completion:
	completionsdir=$${BASHCOMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) \
	                             --variable=completionsdir \
	                             bash-completion)}; \
	if [ -n "$$completionsdir" ]; then \
		install -d $(DESTDIR)$$completionsdir/; \
		for bash in docker-clean docker-archive; do \
			install -m 644 bash-completion/$$bash \
			        $(DESTDIR)$$completionsdir/; \
		done; \
	fi

.PHONY: uninstall
uninstall:
	for bin in docker-clean docker-archive; do \
		rm -f $(DESTDIR)$(PREFIX)/bin/$$bin; \
	done
	for man in docker-clean.1.gz docker-archive.1.gz; do \
		rm -f $(DESTDIR)$(PREFIX)/share/man/man1/$$man; \
	done
	completionsdir=$${BASHCOMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) \
	                             --variable=completionsdir \
	                             bash-completion)}; \
	if [ -n "$$completionsdir" ]; then \
		for bash in docker-clean docker-archive; do \
			rm -f $(DESTDIR)$$completionsdir/$$bash; \
		done; \
	fi

.PHONY: user-install-all
user-install-all: user-install user-install-doc user-install-bash-completion

user-install user-install-doc user-install-bash-completion user-uninstall:
user-%:
	$(MAKE) $* PREFIX=$$HOME/.local BASHCOMPLETIONSDIR=$$HOME/.local/share/bash-completion/completions

.PHONY: tests
tests:
	@./tests.sh

.PHONY: check
check: docker-clean docker-archive
	shellcheck $^

.PHONY: clean
clean:
	rm -f docker-clean.1.gz docker-archive.1.gz
	rm -f PKGBUILD*.aur master.tar.gz src/master.tar.gz *.pkg.tar.xz \
	   -R src/docker-scripts-master/ pkg/docker-scripts/

.PHONY: aur
aur: PKGBUILD.docker-scripts.aur
	for pkgbuild in $^; do \
		makepkg --force --syncdeps -p $$pkgbuild; \
	done

PKGBUILD%.aur: PKGBUILD%
	cp $< $@.tmp
	makepkg --nobuild --nodeps --skipinteg -p $@.tmp
	md5sum="$$(makepkg --geninteg -p $@.tmp)"; \
	sed -e "/pkgver()/,/^$$/d" \
	    -e "/md5sums=/d" \
	    -e "/source=/a$$md5sum" \
	    -i $@.tmp
	mv $@.tmp $@

define do_install_aur =
install-aur-$(1):
	pacman -U $(1).pkg.tar.xz
endef

aurs := $(shell ls -1d *.pkg.tar.xz 2>/dev/null | sed -e 's,.pkg.tar.xz$$,,')
$(foreach aur,$(aurs),$(eval $(call do_install_aur,$(aur))))

%.1: %.1.adoc
	asciidoctor -b manpage -o $@ $<

%.gz: %
	gzip -c $^ >$@

