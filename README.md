# docker-scripts

## NAME

[dosh][1] - run a user shell in a container with pwd bind mounted

[dmake](dmake.1.adoc) - maintain program dependencies running commands in
container

[docker-clean](docker-clean.1.adoc) - remove unused containers and images


[docker-archive](docker-archive.1.adoc) - show archive content

## DESCRIPTION

[dosh][2] runs the _command_ process in a container; using the current _user_,
with _pwd_ bind mounted.

[dmake](dmake) runs on top of *make(1)* using [dosh(1)][1] as default _shell_.

[docker-clean](docker-clean) removes exited containers and dangling images that
take place for nothing.

[docker-archive](docker-archive) displays à la git-log the content of a docker
archive.

## DOCUMENTATION

Using *dmake(1)* and _Makefile_

	$ dmake doc
	sha256:ced062433e33
	asciidoctor -b manpage -o dmake.1 dmake.1.adoc
	gzip -c dmake.1 >dmake.1.gz
	asciidoctor -b manpage -o docker-clean.1 docker-clean.1.adoc
	gzip -c docker-clean.1 >docker-clean.1.gz
	asciidoctor -b manpage -o docker-archive.1 docker-archive.1.adoc
	gzip -c docker-archive.1 >docker-archive.1.gz
	rm docker-archive.1 docker-clean.1 dmake.1
	83727c98a60a9648b20d127c53526e785a051cef2235702071b8504bb1bdca59

## INSTALL

Run the following command to install *docker-scripts*

	$ sudo make install

Traditional variables *DESTDIR* and *PREFIX* can be overridden

	$ sudo PREFIX=/opt/docker-scripts make install

or

	$ DESTDIR=$PWD/pkg PREFIX=/usr make install

## LINKS

Check for man-pages ([dosh(1)][1], [dmake(1)](dmake.1.adoc),
[docker-clean(1)](docker-clean.1.adoc), and
[docker-archive(1)](docker-archive.1.adoc)) and theirs examples
([dosh][3], [dmake](dmake.1.adoc#examples),
[docker-clean](docker-clean.1.adoc#examples)).

Also, here is an extra example that build the documentation

	$ echo FROM ubuntu >Dockerfile
	$ echo RUN apt-get update && apt-get install -y asciidoctor >>Dockerfile

	$ cat Dockerfile
	FROM ubuntu
	RUN apt-get update && apt-get install -y asciidoctor

	$ dosh -c asciidoctor -b manpage -o - dosh.1.adoc | gzip -c - >dosh.1.gz
	sha256:ced062433e33

	$ man ./dosh.1.gz

Enjoy!

## BUGS

Report bugs at *https://github.com/gazoo74/docker-scripts/issues*

## AUTHOR

Written by Gaël PORTAY *gael.portay@savoirfairelinux.com*

## COPYRIGHT

Copyright (c) 2017-2018 Gaël PORTAY

This program is free software: you can redistribute it and/or modify it under
the terms of the MIT License.

[1]: https://www.github.com/gazoo74/dosh/blob/master/dosh.1.adoc
[2]: https://www.github.com/gazoo74/dosh/blob/master/dosh
[3]: https://www.github.com/gazoo74/dosh/blob/master/dosh.1.adoc#examples
