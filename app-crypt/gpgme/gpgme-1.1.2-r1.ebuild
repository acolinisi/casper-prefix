# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gpgme/gpgme-1.1.2-r1.ebuild,v 1.13 2008/01/02 18:26:44 alonbl Exp $

EAPI="prefix"

inherit libtool eutils

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="http://www.gnupg.org/related_software/gpgme"
SRC_URI="mirror://gnupg/gpgme/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=">=dev-libs/libgpg-error-0.5
	dev-libs/pth
	>=app-crypt/gnupg-1.9.20-r1"

RDEPEND="${DEPEND}
	dev-libs/libgcrypt"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-fbsd.patch"

	elibtoolize
}

src_compile() {
	if use selinux; then
		sed -i -e "s:tests = tests:tests = :" Makefile.in || die "sed failed"
	fi

	econf \
		--includedir=${EPREFIX}/usr/include/gpgme \
		--with-gpg=${EPREFIX}/usr/bin/gpg \
		--with-pth=yes \
		--with-gpgsm=${EPREFIX}/usr/bin/gpgsm \
		|| die "econf failed"
	emake CFLAGS="${CFLAGS} -I../assuan/"  || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO VERSION
}
