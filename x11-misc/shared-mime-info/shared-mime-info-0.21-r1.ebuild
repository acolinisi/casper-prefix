# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/shared-mime-info/shared-mime-info-0.21-r1.ebuild,v 1.5 2007/08/08 21:58:23 armin76 Exp $

EAPI="prefix"

inherit autotools eutils fdo-mime

DESCRIPTION="The Shared MIME-info Database specification"
HOMEPAGE="http://www.freedesktop.org/software/shared-mime-info"
SRC_URI="http://www.freedesktop.org/~hadess/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc-macos ~x86 ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/glib-2.2
	>=dev-libs/libxml2-2.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-pkgconfig.patch
	eautomake
}

src_compile() {
	econf --disable-update-mimedb
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog NEWS README
}

pkg_postinst() {

	fdo-mime_mime_database_update

}

# FIXME :
# This ebuild should probably also remove the stuff it now leaves behind
# in /usr/share/mime
