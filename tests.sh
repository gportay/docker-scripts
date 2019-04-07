#!/bin/bash
#
# Copyright (c) 2017-2018 Gaël PORTAY
#
# SPDX-License-Identifier: MIT
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
