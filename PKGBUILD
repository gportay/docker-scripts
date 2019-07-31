# Maintainer: Gaël PORTAY <gael.portay@gmail.com>

pkgname=(docker-scripts docker-archive docker-clean)
pkgbase=docker-scripts
_pkgver=master
pkgver="$_pkgver"
pkgrel=1
pkgdesc='Docker scripts'
arch=('any')
url="https://github.com/gportay/${pkgname[0]}"
license=('MIT')
depends=('docker')
makedepends=('asciidoctor')
source=("https://github.com/gportay/$pkgbase/archive/$_pkgver.tar.gz")

pkgver() {
	cd "$pkgbase-$_pkgver"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
	cd "$pkgbase-$_pkgver"

	make doc
}

package_docker-scripts() {
	depends=("${pkgname[@]:1}")
}

package_docker-archive() {
	pkgdesc="$pkgdesc - show archive content"

	cd "$pkgbase-$_pkgver"

	install -d "$pkgdir/usr/bin/"
	install -m 755 docker-archive "$pkgdir/usr/bin/"
	install -d "$pkgdir/usr/share/man/man1/"
	install -m 644 docker-archive.1.gz "$pkgdir/usr/share/man/man1/"
	install -d "$pkgdir/usr/share/bash-completion/completions"
	install -m 644 bash-completion/docker-archive "$pkgdir/usr/share/bash-completion/completions"
	install -d "$pkgdir/usr/share/licenses/$pkgname/"
	install -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/"
}

package_docker-clean() {
	pkgdesc="$pkgdesc - remove unused containers and images"

	cd "$pkgbase-$_pkgver"

	install -d "$pkgdir/usr/bin/"
	install -m 755 docker-clean "$pkgdir/usr/bin/"
	install -d "$pkgdir/usr/share/man/man1/"
	install -m 644 docker-clean.1.gz "$pkgdir/usr/share/man/man1/"
	install -d "$pkgdir/usr/share/bash-completion/completions"
	install -m 644 bash-completion/docker-clean "$pkgdir/usr/share/bash-completion/completions"
	install -d "$pkgdir/usr/share/licenses/$pkgname/"
	install -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/"
}
