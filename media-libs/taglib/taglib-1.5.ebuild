# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib/taglib-1.5.ebuild,v 1.1 2008/03/20 21:57:15 ingmar Exp $

EAPI="prefix"

inherit autotools eutils flag-o-matic

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://developer.kde.org/~wheeler/taglib.html"
SRC_URI="http://developer.kde.org/~wheeler/files/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~mips-linux ~x86-linux"
IUSE="debug"

RDEPEND=""
DEPEND="dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf # need new libtool for interix
}

src_compile() {
	[[ ${CHOST} == *-interix* ]] && append-flags -D_ALL_SOURCE

	econf $(use_enable debug) || die "econf failed."
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS doc/* || die "dodoc failed."
}
