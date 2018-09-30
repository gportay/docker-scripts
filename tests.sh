#!/bin/bash
#
# Copyright (c) 2017-2018 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
#

set -e

run() {
	id=$((id+1))
	test="#$id: $@"
	echo -e "\e[1mRunning $test...\e[0m"
}

ok() {
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
}

ko() {
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
}

fix() {
	fix=$((fix+1))
	echo -e "\e[1m$test: \e[34m[FIX]\e[0m"
}

bug() {
	bug=$((bug+1))
	echo -e "\e[1m$test: \e[33m[BUG]\e[0m"
}

result() {
	if [ -n "$ok" ]; then
		echo -e "\e[1m\e[32m$ok test(s) succeed!\e[0m"
	fi

	if [ -n "$fix" ]; then
		echo -e "\e[1m\e[34m$fix test(s) fixed!\e[0m" >&2
	fi

	if [ -n "$bug" ]; then
		echo -e "\e[1mWarning: \e[33m$bug test(s) bug!\e[0m" >&2
	fi

	if [ -n "$ko" ]; then
		echo -e "\e[1mError: \e[31m$ko test(s) failed!\e[0m" >&2
		exit 1
	fi
}

PATH="$PWD:$PATH"
trap result 0

run "dmake: Test default target with (Makefile from stdin)"
if echo -e "all:\n\t@cat /etc/os*release" | \
   dmake "$@" -f - | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "dmake: Test option -F with relative path (Makefile from stdin)"
if ( echo -e "all:\n\t@cat /etc/os*release" | \
     dmake "$@" -f - -F Dockerfile.fedora | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)' )
then
	ok
else
	ko
fi
echo

run "dmake: Test option -C with relative path (Makefile from stdin)"
if ( cd .. && dir="${OLDPWD##*/}" && \
     echo -e "all:\n\t@cat /etc/os*release" | \
     dmake "$@" -f - -C "$dir" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "dmake: Test option -C with absolute path (Makefile from stdin)"
if ( cd /tmp && dir="$OLDPWD" && \
     echo -e "all:\n\t@cat /etc/os*release" | \
     dmake "$@" -f - -C "$dir" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "dmake: Test option --sh with a busybox based distro (/bin/ash)"
if ( echo -e "all:\n\t@echo SHELL=\$\$0" | \
     DOSHELL=/bin/zsh dmake "$@" -f - -F Dockerfile.alpine --sh | tee /dev/stderr | \
     grep -q 'SHELL=/bin/sh' )
then
	ok
else
	ko
fi
echo

run "dmake: Test overriding existent \$DOSHELL with a busybox based distro (/bin/ash)"
if ( echo -e "all:\n\t@echo SHELL=\$\$0" | \
     DOSHELL=/bin/ash dmake "$@" -f - -F Dockerfile.alpine | tee /dev/stderr | \
     grep -q 'SHELL=/bin/ash' )
then
	ok
else
	ko
fi
echo

run "dmake: Test overriding nonexistent \$DOSHELL and option --sh with a busybox based distro (/bin/ash)"
if ( echo -e "all:\n\t@echo SHELL=\$\$0" | \
     DOSHELL=/bin/zsh dmake "$@" -f - -F Dockerfile.alpine --sh | tee /dev/stderr | \
     grep -q 'SHELL=/bin/sh' )
then
	ok
else
	ko
fi
echo

run "dmake: Test overriding existent \$DOSHELL in command line argument with a busybox based distro (/bin/ash)"
if ( echo -e "all:\n\t@echo SHELL=\$\$0" | \
     dmake "$@" -f - -F Dockerfile.alpine DOSHELL=/bin/sh | tee /dev/stderr | \
     grep -q 'SHELL=/bin/sh' )
then
	ok
else
	ko
fi
echo

run "docker-clean: Test without option with an exited container"
if cid="$(docker run --detach ubuntu:latest)" && sleep 3 && \
   docker-clean | tee /dev/stderr | \
   grep -q "${cid:0:12}"
then
	ok
else
	ko
fi
echo

run "docker-clean: Test without option with a dangled image"
if cid="$(cat <<EOF | docker build --quiet -
FROM ubuntu:latest
RUN uname
EOF
)" && sleep 3 && \
   docker-clean | tee /dev/stderr | \
   grep -q "Deleted: $cid"
then
	ok
else
	ko
fi
echo

run "docker-clean: Test with option -c with a created image"
if cid="$(docker create ubuntu:latest)" && sleep 3 && \
   docker-clean -c | tee /dev/stderr | \
   grep -q "${cid:0:12}"
then
	ok
else
	ko
fi
echo
