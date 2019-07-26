# Maintainer: Gaël PORTAY <gael.portay@gmail.com>

pkgname=docker-scripts
pkgver=master
pkgrel=1
pkgdesc='Docker scripts'
arch=('any')
url='https://github.com/gportay/docker-scripts'
license=('MIT')
depends=('docker')
makedepends=('asciidoctor')
source=("https://github.com/gportay/docker-scripts/archive/master.tar.gz")

pkgver() {
	cd "$srcdir/docker-scripts-master"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
	cd "$srcdir/docker-scripts-master"

	make doc
}

package() {
	cd "$srcdir/docker-scripts-master"

	install -d "$pkgdir/usr/bin/"
	install -m 755 docker-clean docker-archive "$pkgdir/usr/bin/"
	install -d "$pkgdir/usr/share/man/man1/"
	install -m 644 docker-clean.1.gz docker-archive.1.gz \
	        "$pkgdir/usr/share/man/man1/"
	install -d "$pkgdir/usr/share/bash-completion/completions"
	install -m 644 bash-completion/docker-clean \
	               bash-completion/docker-archive \
	        "$pkgdir/usr/share/bash-completion/completions"
	install -d "$pkgdir/usr/share/licenses/$pkgname/"
	install -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/"
}
