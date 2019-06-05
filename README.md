# docker-scripts

## NAME

[dosh][1] - run a user shell in a container with pwd bind mounted

[domake][4] - maintain program dependencies running commands in container

[docker-clean](docker-clean.1.adoc) - remove unused containers and images


[docker-archive](docker-archive.1.adoc) - show archive content

## DESCRIPTION

[dosh][2] runs the _command_ process in a container; using the current _user_,
with _pwd_ bind mounted.

[domake][5] runs on top of *make(1)* using [dosh(1)][1] as default _shell_.

[docker-clean](docker-clean) removes exited containers and dangling images that
take place for nothing.

[docker-archive](docker-archive) displays à la git-log the content of a docker
archive.

## DOCUMENTATION

Using *domake(1)* and _Makefile_

	$ domake doc
	sha256:ced062433e33
	asciidoctor -b manpage -o docker-clean.1 docker-clean.1.adoc
	gzip -c docker-clean.1 >docker-clean.1.gz
	asciidoctor -b manpage -o docker-archive.1 docker-archive.1.adoc
	gzip -c docker-archive.1 >docker-archive.1.gz
	rm docker-archive.1 docker-clean.1 
	83727c98a60a9648b20d127c53526e785a051cef2235702071b8504bb1bdca59

## INSTALL

Run the following command to install *docker-scripts*

	$ sudo make install

Traditional variables *DESTDIR* and *PREFIX* can be overridden

	$ sudo PREFIX=/opt/docker-scripts make install

or

	$ DESTDIR=$PWD/pkg PREFIX=/usr make install

## LINKS

Check for man-pages ([dosh(1)][1], [domake(1)][4],
[docker-clean(1)](docker-clean.1.adoc), and
[docker-archive(1)](docker-archive.1.adoc)) and theirs examples ([dosh][3],
[domake][6], [docker-clean](docker-clean.1.adoc#examples)).

Enjoy!

## BUGS

Report bugs at *https://github.com/gportay/docker-scripts/issues*

## AUTHOR

Written by Gaël PORTAY *gael.portay@gmail.com*

## COPYRIGHT

Copyright (c) 2017-2018 Gaël PORTAY

This program is free software: you can redistribute it and/or modify it under
the terms of the MIT License.

[1]: https://www.github.com/gportay/dosh/blob/master/dosh.1.adoc
[2]: https://www.github.com/gportay/dosh/blob/master/dosh
[3]: https://www.github.com/gportay/dosh/blob/master/dosh.1.adoc#examples
[4]: https://www.github.com/gportay/domake/blob/master/domake.1.adoc
[5]: https://www.github.com/gportay/domake/blob/master/domake
[6]: https://www.github.com/gportay/domake/blob/master/domake.1.adoc#examples
